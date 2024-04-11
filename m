Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867861442F7;
	Thu, 11 Apr 2024 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829995; cv=none; b=eKGDHGHZEHoXo95Jh8jAZCgQuvfptHNWzJa/Pgc//pu6ue2M2nsISjRnbK+sqd+CI3xwXA4UZOpiCjzGoJak8mwpyZmn/nTAXEG34Oa3+Wr0pesavmHGdDKy9ckBeDDON+38pUvpVUo7XrDRxQrYeqsLBTWuV1KUwlHTVxQcwEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829995; c=relaxed/simple;
	bh=5BBDJllOcpP7Ao7L1CLMvEVSZrDDLBmBtRwg6up3Fx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NesA4jmKIOm4CevCqeUEFOBL5Lb7ptyCjuZfRJcSzvwMq27CNXeMlGUF8YC2o28A8hxfKJOOD+92o4XQmBBf0LIjzFB7gk3/JBxf8Q3T9YdTMW+96q75re66kiMHjQSMJU78iCGEHvXf3KWhRE0B+3OT6ihJoztYqTOmqxGLLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vNrrfqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vNrrfqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D38BC433F1;
	Thu, 11 Apr 2024 10:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829995;
	bh=5BBDJllOcpP7Ao7L1CLMvEVSZrDDLBmBtRwg6up3Fx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vNrrfqvkSzPs0j9gnXapO099a+ktYbO/w/Oh+WBobujRSgU8SVlKUpmfpmmMwap/
	 Wl3MasGTbAFDQVgQusIjMHtPcu4fsBME6N/g7MnLXTQRA/oeqJWqtiFSMbuICR0jQW
	 tWM3Bu3m+8OavdVu7N5GvSPjMsk++89GAfWfns7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/175] tools: iio: replace seekdir() in iio_generic_buffer
Date: Thu, 11 Apr 2024 11:56:26 +0200
Message-ID: <20240411095424.471078894@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 4e6500bfa053dc133021f9c144261b77b0ba7dc8 ]

Replace seekdir() with rewinddir() in order to fix a localized glibc bug.

One of the glibc patches that stable Gentoo is using causes an improper
directory stream positioning bug on 32bit arm. That in turn ends up as a
floating point exception in iio_generic_buffer.

The attached patch provides a fix by using an equivalent function which
should not cause trouble for other distros and is easier to reason about
in general as it obviously always goes back to to the start.

https://sourceware.org/bugzilla/show_bug.cgi?id=31212

Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Link: https://lore.kernel.org/r/20240108103224.3986-1-petre.rodan@subdimension.ro
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index d174487b2f226..1ef51c7e7b04f 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -376,7 +376,7 @@ int build_channel_array(const char *device_dir,
 		goto error_close_dir;
 	}
 
-	seekdir(dp, 0);
+	rewinddir(dp);
 	while (ent = readdir(dp), ent) {
 		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
 			   "_en") == 0) {
-- 
2.43.0



