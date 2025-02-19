Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC51DE4F8;
	Wed, 19 Feb 2025 09:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955888; cv=none; b=CgSebMn2OppR/NJY/2KYvL/AZU+RzYwvGVro3bi8RHjZRi9Rli+MrBUgKTFedojGaZu0PeOgVr1E9QNTR/Ef0MKUsIHaUrsm+L0dsJcr5+6mbl2KqbFpw2rNDZdL2e5EHqS/N7EV+1Ui9PkVp9cMLWMvOXjLb3Depkt/6ExK9JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955888; c=relaxed/simple;
	bh=077S8HrbwTwEA6Om5zTmwsObDeYBWarU2/UBaN7E0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bshi00OIUM3M6bvY06SfR7L2P8opIyatTzzDyLbPgl3YkhXohHdK1t4tMpt/8Y07tzOLvorHHckxJij70jLGIVfI3niYJfSpm5tGI7pxTGhem++7vs77CdihN07LvhHmt7qlYDrN0k5RYW/h6jeMbOjnKCW8qQCQDnsreCK1XbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLidAt0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLidAt0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B380EC4CEE7;
	Wed, 19 Feb 2025 09:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955888;
	bh=077S8HrbwTwEA6Om5zTmwsObDeYBWarU2/UBaN7E0Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLidAt0yqRe5/P7e+8tYCnAe9tbX3KluOoPw9nqn0LKjhi89DMf9BksA/yLqNUSXw
	 FiL3Wuy9+U6dwlJK6bQqBqJYkP9QJMuNgdHcG9inGE28eqpvQt9ZZ+JgJj+lH8DsVt
	 MXWm8Uy/WfeYk3f/BlMx2eTSEEP1T76tlxN2fwu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 147/152] HID: hid-steam: Dont use cancel_delayed_work_sync in IRQ context
Date: Wed, 19 Feb 2025 09:29:20 +0100
Message-ID: <20250219082555.864348315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

commit b051ffa2aeb2a60e092387b6fb2af1ad42f51a3c upstream.

Lockdep reported that, as steam_do_deck_input_event is called from
steam_raw_event inside of an IRQ context, it can lead to issues if that IRQ
occurs while the work to be cancelled is running. By using cancel_delayed_work,
this issue can be avoided. The exact ordering of the work and the event
processing is not super important, so this is safe.

Fixes: cd438e57dd05 ("HID: hid-steam: Add gamepad-only mode switched to by holding options")
Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-steam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1615,7 +1615,7 @@ static void steam_do_deck_input_event(st
 
 	if (!(b9 & BIT(6)) && steam->did_mode_switch) {
 		steam->did_mode_switch = false;
-		cancel_delayed_work_sync(&steam->mode_switch);
+		cancel_delayed_work(&steam->mode_switch);
 	} else if (!steam->client_opened && (b9 & BIT(6)) && !steam->did_mode_switch) {
 		steam->did_mode_switch = true;
 		schedule_delayed_work(&steam->mode_switch, 45 * HZ / 100);


