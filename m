Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632647140C;
	Tue, 21 Jul 2026 20:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665449; cv=none; b=mNEo56tr2Taf7+LaCYWxxiB0spstyD+XPmokX4X9m/dplGGPWRz15CnAfJ50cRlokLrIw2sL6SxhLgaN9kgiDFJ1BalUZiT1TreDMERYT95jWGpu09KlVa5UrteoopDHa25j8NWxbKNCVLp+DqqQVGciK+MDUeu9WDBPyNu4/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665449; c=relaxed/simple;
	bh=ul7HuffvwPkPd7gZxgCFSwIUE4DH+pRlPzdmkxJjfFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdMZ1ofm70f3ZtHssR+8NMDF5Z6YJuonfO30Cle2bhbh1zUxaG58QqgVDyV98SJgwu+agGyMjlKsouzDTuWza8uYg9ViHM2H1pFVCxISraGDNP4H8+k+lWeV+0eTgejogrq6mXOFBzTP3uJ0ur9TgIGJK9lyPpmaBtVzVcTgzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rObB1p+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rObB1p+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA21F000E9;
	Tue, 21 Jul 2026 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665448;
	bh=o4CEAGpkZOOMVtXiGBaAW9p5Q2MnOqeVGsZgRvJ1wIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rObB1p+BQyeq5J8IPZOdrChtb8O5AlET6JOqOikqzRzxDwwTlT/S9gipV704VI7QA
	 NQ/AUi5EdXKxS1pURz4VJK0CgKHo7Rj9cy1c+AIUr29LWquE1+6EsSXndtdxZ2wNOu
	 GdtLLB2M+80E8rJFX/Hjk/wgycg8idnR7hffDk9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0307/1266] Input: synaptics-rmi4 - bound the F30 keymap to the GPIO/LED count
Date: Tue, 21 Jul 2026 17:12:24 +0200
Message-ID: <20260721152448.700402852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


