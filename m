Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECED4611E1;
	Sat, 12 Sep 2026 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228247; cv=none; b=Yain1G82cfWwCL73YtrWpLNcq0Lci2eG3LA6zEpp9u6Wdre+fBh5yip5fH7i7YXqXcizivIs/pzsB31V2IwiZvisv5qXsZJbhjLpiEB+KmYuZlt7Xc8zmpnfRpxqIVgaca6kls6iz+pEjIDh7hfZp8j4CZeFhC1VvPr0RPPA+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228247; c=relaxed/simple;
	bh=hdPvh1q3eVkI4U/wO9F3/ErksIsT+O/d2S0xAYCyQ24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZb0DZWUEu0lMT0M0ckKsBdVRlVSY/hJF9HkEwb53FsFNLEiGqLoUziuRQW6RmnHQdk0zaEu0W29EFpVgU6O9AkMJSWrJvzngqAV0qA3DYTxD19Mia86P1OXZWQSgGr6P8+fO7p6KxmlsjL3y2Dm4t6JM1EWF0Hd58uz1XsxSrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqlDnGEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqlDnGEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08041F000FF;
	Sat, 12 Sep 2026 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228245;
	bh=Tm0ODUFEo4RMOHnE5k7Dknl+tR3f+XNFVRF2wdT8eK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqlDnGEmjjh5oLdSeAZY3NaXOuEw71rCHKdxYhiQPd8fHjrwjx9SasLYOzi6jg/GC
	 4L3YF0zpBXV6Kw9KYQsqst49Xx9P6z9YrK9CuakitCqm0LorT65YJkStdGOK5J6K9X
	 YOYwjps9NXpo8waWJplF8V1dUs1ihb5Usk9AJoI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0346/1191] iio: light: cm32181: return zero after writing calibscale
Date: Sat, 12 Sep 2026 08:51:14 +0200
Message-ID: <20260912065555.999781981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -370,7 +370,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


