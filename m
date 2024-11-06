Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA21E0DBD;
	Wed,  6 Nov 2024 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898675; cv=none; b=dp18o8o/jhKOx38BYm8Fz9w9Fte8BbtZii7JxgmQ5+FmJyGwEVLzSewqnkCuwgA8M9j7pQtQpn1n/bmuLRKCAjFyuAq44ijoFuBRiv/NICF1ftqq7CXhAf9mHSIib5PgQnBx82OQ0H1176ylRllYW0nHi6++MvWCTGDH/mGGTQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898675; c=relaxed/simple;
	bh=eXsv5yWI+heAXZ7C2W03xBXAEnqQAd4dq1smuGXZmmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQkptipUIr6w5CCNHmrgZTvnHx+FYczFVWLIrxMoJxjOSHPzNBvoMBetG31sYsuJi5NIyx4x6MZblW/aMjRdUAL/yqRdoniJXcQo+1wmfwBnmu9gYHSXRKLKJFbn8PLtDzSEhVXgGtSvu/N43WXJECx8X1+1cHBOG4k5udoc8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksqiNmw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksqiNmw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B68CC4CED3;
	Wed,  6 Nov 2024 13:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898674;
	bh=eXsv5yWI+heAXZ7C2W03xBXAEnqQAd4dq1smuGXZmmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksqiNmw+DBwgOB7bEt1iMEbftwfQIJvPtNGRXoFwrkqegweQ4yQNDL5yd0eD2ghKv
	 G/lctlFTaIIOz0s1Tbt9tavRwCujC5Y4RoBZE4Sr+n0yQmruhc/Jp2mj+xD+H2uDh6
	 pkl7J2kvzyDQcViB96TcVPfyRHtDwEQUwHZ4wTFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 318/462] tools/iio: Add memory allocation failure check for trigger_name
Date: Wed,  6 Nov 2024 13:03:31 +0100
Message-ID: <20241106120339.380778898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 3c6b818b097dd6932859bcc3d6722a74ec5931c1 ]

Added a check to handle memory allocation failure for `trigger_name`
and return `-ENOMEM`.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240828093129.3040-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 2fd10eab75b53..5ef09ac6e7cf7 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -479,6 +479,10 @@ int main(int argc, char **argv)
 			return -ENOMEM;
 		}
 		trigger_name = malloc(IIO_MAX_NAME_LENGTH);
+		if (!trigger_name) {
+			ret = -ENOMEM;
+			goto error;
+		}
 		ret = read_sysfs_string("name", trig_dev_name, trigger_name);
 		free(trig_dev_name);
 		if (ret < 0) {
-- 
2.43.0



