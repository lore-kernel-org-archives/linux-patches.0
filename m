Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EBC335BA7;
	Mon, 18 Aug 2025 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525045; cv=none; b=l5Ja2bspjcdvKsK/hlLEg6upOjxGOatzL85kVEW8foYwpQUNXqtJYt3fxcHj736HkBkFpWkA20E6XDYYf7809mnidONtA9S2BnHbbUz5W5RRQmGwX50aen+pOt+NoW7WjTr28cj07N7yBtv2YF2xihM9OGt6jPaYx9MWKzKRqFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525045; c=relaxed/simple;
	bh=OIi9tMV8SlqSnaBK7J9yKdJTgWFKOa42QhU7+cLXXTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOidArUatvGR30c2oQkylhMHSSgviljlA5oDbAeTvHjuRHnhqEVRlkFymIVVONXyhAL83iAAhATGbzgIxtf318b71jKuqY0c9h0LO+s8oo7SX8iLf1WXv7Gsn7cJ34/z3M8VVBBngSkaG82KgVGBJJ71DhaneYjqCBzpJnCXLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFqnZB3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFqnZB3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84008C4CEEB;
	Mon, 18 Aug 2025 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525045;
	bh=OIi9tMV8SlqSnaBK7J9yKdJTgWFKOa42QhU7+cLXXTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFqnZB3Mri0cwizChbhrSjLWU64fQSq9o4eiYNQ84rgyOEd/FvG5DYP1VCss1Ac0F
	 P24qYJach+nFbp8d/5cL2ssyw9BsyhLuyKE1ERkc+/FwTN9mJJd4lhCHz8Tur7gV2y
	 iKKc0hEB8wBApfXHpFwkbHJpJLTJq0mlQ4t4ZgN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 142/570] usb: typec: ucsi: Add poll_cci operation to cros_ec_ucsi
Date: Mon, 18 Aug 2025 14:42:09 +0200
Message-ID: <20250818124511.294586838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

[ Upstream commit 300386d117a98961fc1d612d1f1a61997d731b8a ]

cros_ec_ucsi fails to allocate a UCSI instance in it's probe function
because it does not define all operations checked by ucsi_create.
Update cros_ec_ucsi operations to use the same function for read_cci
and poll_cci.

Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250711202033.2201305-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/cros_ec_ucsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
index 4ec1c6d22310..eed2a7d0ebc6 100644
--- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
+++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
@@ -137,6 +137,7 @@ static int cros_ucsi_sync_control(struct ucsi *ucsi, u64 cmd, u32 *cci,
 static const struct ucsi_operations cros_ucsi_ops = {
 	.read_version = cros_ucsi_read_version,
 	.read_cci = cros_ucsi_read_cci,
+	.poll_cci = cros_ucsi_read_cci,
 	.read_message_in = cros_ucsi_read_message_in,
 	.async_control = cros_ucsi_async_control,
 	.sync_control = cros_ucsi_sync_control,
-- 
2.39.5



