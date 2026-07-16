Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3C3FE653;
	Thu, 16 Jul 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212503; cv=none; b=KYtxK4g1EVPChr1K5+615DB2yIt4Dfw7dH9w67+abBvY5IUqZfFltjm1IJB9f+TKXNV8jnR9kbelu7r5Hmtc5QwRrbAKNx0KD0QxA2FaGkeikk3NQa8QlDxFe5IQpPA+Y9srwukYpQ3eWObbO7dXnc/aVzXXvbAhI2s7GHyxlT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212503; c=relaxed/simple;
	bh=AclL+FwRwcVEKN2ejclqMB+4azDC6zqgw7XtK1p1jCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tc2G3dpyJPJkgUMwymb3dvyPtD8kRKpbbkcKX86bbJzbBjK51ecQcy3ubcqbjNh7CTbX65mEePxX4jpTN8nd7/HgvA9QMngXZtaorkZKUIdG+VugReQO+9qsYFEzffVXL/o/i/9EezP/prlx6uVLyKcRrHiOH7J3RhYQDTLlQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCxY2hGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCxY2hGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53AD1F000E9;
	Thu, 16 Jul 2026 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212502;
	bh=a2McLN2H+cZf90dz5XxatT5DX48WkBmZhVrdpP0a8/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCxY2hGLBzX0n0ZQ1GqrOf4cNBv10D8Zuo1UjjNqmmsmYNTIVTI2XlykDjpq8Gp8z
	 u6oKPOWuhVl+qXIA3RAEOdNxFNCHcTBlQtKrNZXOAgLWfKlgBXCoy8VVOk5ps31/5l
	 JEwM5oKgnYQL1zAt5ffi5hPlPr6VH2bmtOZ1iliI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 332/349] Input: synaptics-rmi4 - bound the F30 keymap to the GPIO/LED count
Date: Thu, 16 Jul 2026 15:34:26 +0200
Message-ID: <20260716133040.744642260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d577e46785d45484b2ab7e7309c49b18764bf56c upstream.

rmi_f30_map_gpios() allocates gpioled_key_map with
min(gpioled_count, TRACKSTICK_RANGE_END) == at most 6 entries, but
rmi_f30_attention() iterates the full f30->gpioled_count (device query
register, range 0..31) and dereferences gpioled_key_map[i], and
input->keycodemax is set to the full gpioled_count while input->keycode
points at the 6-entry allocation.

A device that reports gpioled_count > 6 with GPIO support enabled
therefore causes an out-of-bounds read on the attention interrupt and
out-of-bounds read/write through the EVIOCGKEYCODE/EVIOCSKEYCODE ioctls,
which bound the index only against keycodemax. This is the same defect
as the F3A handler, which was copied from F30.

Size the keymap for the full gpioled_count; the mapping loop still
assigns only the first min(gpioled_count, TRACKSTICK_RANGE_END) entries.

Fixes: 3e64fcbdbd10 ("Input: synaptics-rmi4 - limit the range of what GPIOs are buttons")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260614-b4-disp-818d6bda-v1-2-cf39a3615085@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f30.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f30.c
+++ b/drivers/input/rmi4/rmi_f30.c
@@ -233,7 +233,7 @@ static int rmi_f30_map_gpios(struct rmi_
 	int button_count = min_t(u8, f30->gpioled_count, TRACKSTICK_RANGE_END);
 
 	f30->gpioled_key_map = devm_kcalloc(&fn->dev,
-					    button_count,
+					    f30->gpioled_count,
 					    sizeof(f30->gpioled_key_map[0]),
 					    GFP_KERNEL);
 	if (!f30->gpioled_key_map) {


