Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6591756B68;
	Tue, 23 Jan 2024 00:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970038; cv=none; b=PA66wvVb77cddDSCiahDb9a08XwhyNzkwoVcKl2VrIdfe9ZoDBGrhFBO7KtA1dV9vGUGRJBGLo/k7rpJ3s6ijRyY6/Lf+NrqLuS51ltHhuzVN9apRlY4G1whlXKo1zSZtWtjz7l2kjtq4lH0OjhqaN6vdu6RfBgI1FmacHlLoqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970038; c=relaxed/simple;
	bh=uOjbrtXcvWNsROkAqS5BKyNR0SwhzVzrUvmvtOoe9ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAsuqGqS2R4ZJdIrl2Mj2Nvqvr1C06mMMLxthuscP4TEEIDmSX4gasEWx8MC6Fd5UkwxBa/VrssD1VTKxQ9xX9i4x8k9tAbo3qCCk+fgqQWaB4zRKQi8OeOCMV1BKJy2jU4XrII0NuiGC8EUEScUMDdk3jsvwkY4+fZn4SvKqXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUDIkQTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUDIkQTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1CCC433F1;
	Tue, 23 Jan 2024 00:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970038;
	bh=uOjbrtXcvWNsROkAqS5BKyNR0SwhzVzrUvmvtOoe9ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUDIkQTAMib1upRC+m/9VnqJEsmUhXEUNOkeXyuVJq4LoOI+KkiASCI6inyDl642J
	 wnRKdCZPAnpeOOQUyi6OXQIFYilYdsyTut8z2tutygDywsZ7UAsN0PYaJNmB9Lb0cc
	 kXfCwYH+F+jA2nEOrw/od8XEEbl4gKqP2Pq4loNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 571/641] nvmet: re-fix tracing strncpy() warning
Date: Mon, 22 Jan 2024 15:57:55 -0800
Message-ID: <20240122235836.027911132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4ee7ffeb4ce50c80bc4504db6f39b25a2df6bcf4 ]

An earlier patch had tried to address a warning about a string copy with
missing zero termination:

drivers/nvme/target/trace.h:52:3: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]

The new version causes a different warning with some compiler versions, notably
gcc-9 and gcc-10, and also misses the zero padding that was apparently done
intentionally in the original code:

drivers/nvme/target/trace.h:56:2: error: 'strncpy' specified bound depends on the length of the source argument [-Werror=stringop-overflow=]

Change it to use strscpy_pad() with the original length, which will give
a properly padded and zero-terminated string as well as avoiding the warning.

Fixes: d86481e924a7 ("nvmet: use min of device_path and disk len")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/trace.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/trace.h b/drivers/nvme/target/trace.h
index 6109b3806b12..155334ddc13f 100644
--- a/drivers/nvme/target/trace.h
+++ b/drivers/nvme/target/trace.h
@@ -53,8 +53,7 @@ static inline void __assign_req_name(char *name, struct nvmet_req *req)
 		return;
 	}
 
-	strncpy(name, req->ns->device_path,
-		min_t(size_t, DISK_NAME_LEN, strlen(req->ns->device_path)));
+	strscpy_pad(name, req->ns->device_path, DISK_NAME_LEN);
 }
 #endif
 
-- 
2.43.0



