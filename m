Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5393DD51A;
	Sat, 12 Sep 2026 11:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211243; cv=none; b=bXeb62x2jd9XlYVUPYlV7KJeE7RWYWAevq/80sOzi05GaFqWt/0hAW/EdrMQQ1FcgtjHGi4cjQoRkMsqh/yn56+ttjesX+RBU18t+dOVuuU0nPcwLmpoZFIGuEKQBH6FOpV/kBCullP5gFFKReYyJ3m4jiSdzsQG3V2JKJdI7WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211243; c=relaxed/simple;
	bh=7MWNPHRXW6fMY6+dc7FN63DdAcYMWNbW+sgGaQ9WN7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3aclZad0xEisTzZnNwCpoydjLzEfKg4HDLRSHuNpfN2jAjGl/MZi0Qc3RKoApJrgS0YFrDxeUntt5eQHIIMgPdG350h3pDyfW9b6AW2aWt/FYzmq2HQHxCawdxMH4/m/Ujd/VwMNg/ikCySjF7XODig9/FiTFIer9W+je6C+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bfl7S2vF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bfl7S2vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4A21F000FF;
	Sat, 12 Sep 2026 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211242;
	bh=AKILaOYczL1jCfarkl+RlD/2fYq9PZsfSbNEFFCOfxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfl7S2vFMfgLtMrGd6RsFJsk23+OGDyLaAek2i7aE3JpZRjcP36F3ZBCqEjPI7VUQ
	 LparrQWiLPSNs9OYixNW6lKvU9RiHg9ae9sMs5lZksJfjrJR8F1cv3yRnppUmBuB8C
	 PIO62xT/uDS9MWQAt5iP3ByUu237RprAklQjhy7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1189/1518] HID: haptic: dont write an uninitialized value to unhandled usages
Date: Sat, 12 Sep 2026 08:55:58 +0200
Message-ID: <20260912065650.375487502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index fc8a9997f8153..575692580ab90 100644
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



