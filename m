Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53835284883;
	Tue, 12 May 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609579; cv=none; b=GAaKc0f3r5t8AmmB96d8zlJm4r6z46TbtyS5skD4lxfJ8EtTL4A6GxHXAc/bFcu+u4hRp4hIy3KJEc1R/W6O0HIwgWINo00SZNC6QjbIA0QQbGOCK1C9Xe0+KpHk1uKnfKlBuxGxf5oIiDukFPBYxpufO5gjMuuoQiLYD1ZuM3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609579; c=relaxed/simple;
	bh=CFcGdLiCIYvd+kBpLpk1/9GN3zWqb26CqFiWeamJ2UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrV0BcrLUA5oQsVFLD9A6BcS+flsb5257PSfYfE2df80YYv6OY6LvpCFETjrdC0D1at/oXDRNuy8uGpPIV70nmgyRhzhr2v/xs5QAJvnZYeP3sCra4RyloKb5Gpdj093GFhQ99z/4NyGF2be5s0EuhaTBQbVJIDz/OpNwkXxYB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhcbP/ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhcbP/ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF83C2BCB0;
	Tue, 12 May 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609579;
	bh=CFcGdLiCIYvd+kBpLpk1/9GN3zWqb26CqFiWeamJ2UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhcbP/aeP84vJwILYWL/y4Saa/h6dfxEq9nSqvfV9P90LalcsH/aOpH2k4vU0S4mI
	 gfXLW9dmSUpUPCWvEFKBk5CL4N/fTXQt+5t3QVBVRzI/LnYAtPf8or1RGdo0N62YeX
	 uUQV74v+0iIBjLQYYjwXhIgOfc33SBj1lqjDh3Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.0 208/307] s390/debug: Reject zero-length input in debug_input_flush_fn()
Date: Tue, 12 May 2026 19:40:03 +0200
Message-ID: <20260512173944.507846258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit e14622a7584f9608927c59a7d6ae4a0999dc545e upstream.

debug_input_flush_fn() always copies one byte from the userspace buffer
with copy_from_user() regardless of the supplied write length. A
zero-length write therefore reads one byte beyond the caller's buffer.
If the stale byte happens to be '-' or a digit the debug log is
silently flushed. With an unmapped buffer the call returns -EFAULT.

Reject zero-length writes before copying from userspace.

Cc: stable@vger.kernel.org # v5.10+
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/debug.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1584,6 +1584,11 @@ static int debug_input_flush_fn(debug_in
 	char input_buf[1];
 	int rc = user_len;
 
+	if (!user_len) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	if (user_len > 0x10000)
 		user_len = 0x10000;
 	if (*offset != 0) {


