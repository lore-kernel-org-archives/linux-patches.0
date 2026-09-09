Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D55616B5;
	Wed,  9 Sep 2026 13:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962399; cv=none; b=AERVGbNW8lCz2NeohXJOpYx+WiMBNPcZuGNRKQSAgAzqYV5zZNKagAW0+tDDaf4DQ3doVkA96e5oV1yJCxsYRXwiqaeGPzbBXW43+qeB4IUQKsyotyFZnQQ5xAzugtLD/AvY9iu2X/scGVlGr0hLr/COoMXpfCF66xgpy1DN6/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962399; c=relaxed/simple;
	bh=FsOUf8HkYFlTiEVFaYf74Mg/SnI5UWbkjXFBRRc7Mi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZzXZcHTYZEv6/MyQe8kj6LEbRFvaack+x1YdXhXxRHct6+S9ee97eOou1S0JJWdWAGhL51ZkqGzKRc/wO9zYtsOqfWQLFXHsIB7S69wmekPa09IzTgcV1J9oX/hCD0gWQ+lMIchufaAGQ4J2tupVDMlzgdlDaqnakrpNBnmUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7XyZ1WI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7XyZ1WI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088F91F00A3A;
	Wed,  9 Sep 2026 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962398;
	bh=OVklb/O4djk1/wqDHGNFcaJSvt3Tu/h4E+D3myujGlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7XyZ1WIqiZMECFRDmSVwaT9fb4wXSb2vMMJYiqMBCPrC5OXN++1KxkR9EJVJebgb
	 ptVzcB47ET8G7pjG1FDM7MaYfRhk5Yppx9Qt9ff5R9DmapPVPl0bTE74NrBQKwhwNI
	 XsTVUVTXSe9CvFAv39Fdyf6BdLS8C4FdI9Gw7fXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 277/556] iio: light: cm32181: return zero after writing calibscale
Date: Wed,  9 Sep 2026 15:39:17 +0200
Message-ID: <20260909134240.371873087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -368,7 +368,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


