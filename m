Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4849144AB73;
	Tue, 21 Jul 2026 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668603; cv=none; b=K6a+Q+Q/04roi+JsxN0NcRWL4ReNJSBEup5NF4HoM/vX4ejiNzPLsaTW8fCtIc2GcslpL+vLtOOXK9kymOZuwX+HexAMATrUbO+1KBEBtdVjdOyiKCxKOpzr/RxQxhrhtzLq0sJ2ab7hvWH71paQMP+oveZp9A0l57g8TzgAqcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668603; c=relaxed/simple;
	bh=Pgf4yrq2lzGoFPzknjez0Efd9ZmE5WRbp2lT+7pXZRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBFSwxI+aT6dKWxQCdwSbdTGMUFHxpgW360Eo5hpi9mUCF+BITpCwIQOJO1ygK1mZKdBW5/kSrWMAv0cgPS9Xdzf3NwYivKqA5attE8X82WT89lINe5e2eyM7PKrrQ3sq94bdBiSDcXQ/63HnC6n+i3Z6D04fShCcDseZsSDxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiWx696g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiWx696g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF1F1F000E9;
	Tue, 21 Jul 2026 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668602;
	bh=dqf0B240UKnjqiCX30kiZE2xyHgdJ8Dfwecnvrj2hsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiWx696gm9OS57ZM2YTuU2BxCBkWQjSGdOJC3Fsmby7gBarcHA1iOF66ekYDv2/+9
	 VAxNgze5KbKXcbC2j1vIizBRquoSJDbSTWZ5XOWEQku5YSF6OoCt0Q7kjNdX6scuWx
	 8UmmdiIat3Mrmr7MZMZJev3LczWHiSm3wbWLmM1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0236/1067] Input: synaptics-rmi4 - bound the F30 keymap to the GPIO/LED count
Date: Tue, 21 Jul 2026 17:13:57 +0200
Message-ID: <20260721152429.878742131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


