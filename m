Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE841A4E7;
	Sat, 12 Sep 2026 09:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203650; cv=none; b=Y1S21CaBxZ20PWDubqtvwb80FQeUkdTiWnbCuTuMBkh2D4bx/+2VqzNRFy2wWQGP31zsrklxl1+IJ1zn5UrEVGT+TdGE1YYd/pE5nkcV/jlV21APYabXyup2qHpLwNCLyKrjpsu5WjOF2tW0htcSa6VKIpoOmgnwFs0yT5h0gTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203650; c=relaxed/simple;
	bh=omwEkXb+HfS+Co1SRjsDj1xGWqYrjC6YiXk7w2wVKPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REVINjoh5n6e6lZZqOhVX5InxuJBSSHWSnb43GTthtx4t127EEKkVUojBoimm1kC27otbeHVcJzkAlDKYBTbKkPseIBh1Ws2URXoXs+YzwDzeL82rxhAxP3L5rPX/8ZWdl0o0E2LPGOHc2fuG49do4wFH8h/IDeEuReJjxB6BtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCQNX1hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCQNX1hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A00E1F000FF;
	Sat, 12 Sep 2026 09:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203649;
	bh=gisi8s/0Q7TJ4CB0XPMQ2eNPPiOgm5ejMBWlgz7MOJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCQNX1hbPYxTQ5UGw3qH0SvFrl5AqFnBtYpqvtv01nbiPNRxgdmo/NnM7/CWMRpe3
	 NCR5yUAdyBiOAkss46zDLkmrtgKoNhonDzOeQ8JxehgbhuehngJDeYsOLQmFOCF9ZQ
	 VVw3hHkgg2FSqRUcOZ+Py9EXkzjOPgVSciXmXtHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1450/1815] HID: haptic: dont write an uninitialized value to unhandled usages
Date: Sat, 12 Sep 2026 08:53:20 +0200
Message-ID: <20260912065723.054544136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3efb7f6491526f5012f9ec94769e9ed832feeef8 ]

fill_effect_buf() initializes value only for the four haptic usages
handled by its switch, but writes it to field->value[] for every usage.
An unhandled usage can therefore receive either an uninitialized value
or one left over from the previous usage. hid_output_report() then
serializes that value into the effect's report buffer.

Skip unhandled usages instead. This also matches switch_mode(), which
only updates fields it recognizes.

Found with Clang's -Wconditional-uninitialized.

Fixes: 344ff3584957 ("HID: haptic: initialize haptic device")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-haptic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-haptic.c b/drivers/hid/hid-haptic.c
index deadab28cdbef..66d90f0f78a3b 100644
--- a/drivers/hid/hid-haptic.c
+++ b/drivers/hid/hid-haptic.c
@@ -187,7 +187,7 @@ static void fill_effect_buf(struct hid_haptic_device *haptic,
 				value = waveform_ordinal;
 				break;
 			default:
-				break;
+				continue;
 			}
 
 			field->value[j] = value;
-- 
2.53.0



