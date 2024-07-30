Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDEC1A6192;
	Tue, 30 Jul 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359112; cv=none; b=A7vgpC7RQ4XfGsy99NpKtqTDR28U3EojiLt3xTzH6tN0+KEyz/uBpgExgyRPyJ3RGscJ0Ybx8s5KpZu0g3dYIx0TznIubCgaGV7HRKbNz9pNPvnAMuuIRQRb2/CC68wZ+woJRo1IJAq/E8hxJQhux5HiwiRmWbUxl817nPGWI9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359112; c=relaxed/simple;
	bh=IjpcMMqTanEQqA/WGmBiZ6796PMwPO82nlZW94RZZpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwKL3q34hkR+xcog6lkFAE3O6liUrTIWJqwK4VQqPTXfZyqb9ngoYvpzuUghonoh9z4VkA1lJXhipip2PhUyo7fVf34deWUz/guxOTTw9EzN94zIZh9DQPTITqWkXWSG7TMWAKeVgoNS5gWD6UH0aRgLODilvDbpUZ1aa1X1Bjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt9/NOg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt9/NOg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6597DC32782;
	Tue, 30 Jul 2024 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359111;
	bh=IjpcMMqTanEQqA/WGmBiZ6796PMwPO82nlZW94RZZpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt9/NOg/6JALkOHYT/9+h/KqVWhHGBf9oB7QCZGUfcvdDwOsyp269o5zXddu5e7A4
	 8nnBbYh2zrOY4dyNqtZQor69N/MdzwG1ryRBmZLewKf6btovYQq36Occ/+tl76ZrMB
	 wVRV4JLTh+ADQOOdKceAGpMdoSuBxpyq1VeojPtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 433/568] fs/ntfs3: Update log->page_{mask,bits} if log->page_size changed
Date: Tue, 30 Jul 2024 17:49:00 +0200
Message-ID: <20240730151656.794717018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 2fef55d8f78383c8e6d6d4c014b9597375132696 upstream.

If an NTFS file system is mounted to another system with different
PAGE_SIZE from the original system, log->page_size will change in
log_replay(), but log->page_{mask,bits} don't change correspondingly.
This will cause a panic because "u32 bytes = log->page_size - page_off"
will get a negative value in the later read_log_page().

Cc: stable@vger.kernel.org
Fixes: b46acd6a6a627d876898e ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3922,6 +3922,9 @@ check_restart_area:
 		goto out;
 	}
 
+	log->page_mask = log->page_size - 1;
+	log->page_bits = blksize_bits(log->page_size);
+
 	/* If the file size has shrunk then we won't mount it. */
 	if (log->l_size < le64_to_cpu(ra2->l_size)) {
 		err = -EINVAL;


