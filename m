Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9283F46EC7B;
	Tue, 21 Jul 2026 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659100; cv=none; b=Z5+L0cj/UlQpVC4vyzcMEdjW7jx/SPQ+UkOvw9WOyR+VU2703wtCok6DiLaKKVX1sTy8Antur/ERIC7prmL4Uxp8Tz7mwFHNnqqBx7SyrEf3QGpP2Tz8SUc5hJ3OD9Xu5FgYW9wWwdS72LyoaRd/v9cxM2EWMtTRRU+DzqSnAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659100; c=relaxed/simple;
	bh=g6n4oodtkJJTLGqITR9JQwtZKKupoL5QXdETeEPMmpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grQPXC/QGgs3R/OXZe1XrlfEwRb4uhtEAHsYQ8NtM+ttx6O0x1+bHRXFeSclaRYa5hbhKKYl926bzgbU5H1J1Mr03RLnRG8wjsw4SyehBgjovW0BHGkYYU5YyuMJ3Lz75+3wNrh2p5jYSH646TWiXKvsg7sD/vgtsWgpLSCLJwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VY9f8GvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VY9f8GvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA17B1F000E9;
	Tue, 21 Jul 2026 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659099;
	bh=k8jrU60ToBOWymD8IAUjetGYulMTtT2vrkRdueMqyB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VY9f8GvPU23FM8wYZPfM16dzG4jHrn/nRCA6I3Oru9t/cMPn6fmNcnTO47IgBsA6m
	 pIDSyaKgc8Kp5JNM6oaBRZ4zywNuKRf5VXG9Tbnu/gcNif+5+8fULB5rog4eWOCo7D
	 MR54EGrK/3jQayI+Lvd7fr63Vq/UWKSdZPJ+NINk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1349/1611] dm-ioctl: fix a possible overflow in list_version_get_info
Date: Tue, 21 Jul 2026 17:24:25 +0200
Message-ID: <20260721152545.799926621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 76c6f845dc0c614304a6e6ee619b552f97cf24b3 upstream.

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -683,7 +683,7 @@ static void list_version_get_info(struct
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}


