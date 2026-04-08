Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE3132A3FD;
	Wed,  8 Apr 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673753; cv=none; b=pVXtSnUD4bx39L0hkC4vZAgA0Qg/rBTWYQ8T7AKMh4yp+FDAN/hh6+wOK/uCKyjLc6ejTqBEh/OGKJY8THF1EZSafJdWh225GZvpsjXyEme3iQvvLYv/knQLBNMi9kPXWizHuXRtq587MR6Erk5OThKLJa2DK+o5qf9sIz7awks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673753; c=relaxed/simple;
	bh=X8xKL0zaf8uYiWU3qid33Nra1xTSPOS5aEZuATTQlyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKj4tj90ppXesVcfM6f8Z8MNVDUEpwjTqh3ImTd5nBlcRX2OO7zvzwTSZRuhd5LKt1TQXZDu7GqFREOZvcN+6F/gGNE8/iDuaTufDl+wDrzv8KH68UAGBNRtMJe6ZblXikMDF7vofOu7Y0JVBCJysMHYwUmMDD0QiVCJpKUPB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpKb0nQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpKb0nQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C94C19421;
	Wed,  8 Apr 2026 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673753;
	bh=X8xKL0zaf8uYiWU3qid33Nra1xTSPOS5aEZuATTQlyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpKb0nQMXkqELBZmIftHdF+cRlKAjzqG1KuzLcWdr11s701UAaXmAVlTI9Od9PhjG
	 Fb84WTO85rTw2tdCt1EpICY3M57d92GdfTdQ/DR4M88BfPhW6Ps6Sl9oFTm7MRXyPp
	 AYg1O4azs9qeBvU1bIzxxwdrsxYo6n6R8HJFAL1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/242] HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure
Date: Wed,  8 Apr 2026 20:01:14 +0200
Message-ID: <20260408175928.348708808@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit f7a4c78bfeb320299c1b641500fe7761eadbd101 ]

Presently, if the force feedback initialisation fails when probing the
Logitech G920 Driving Force Racing Wheel for Xbox One, an error number
will be returned and propagated before the userspace infrastructure
(sysfs and /dev/input) has been torn down.  If userspace ignores the
errors and continues to use its references to these dangling entities, a
UAF will promptly follow.

We have 2 options; continue to return the error, but ensure that all of
the infrastructure is torn down accordingly or continue to treat this
condition as a warning by emitting the message but returning success.
It is thought that the original author's intention was to emit the
warning but keep the device functional, less the force feedback feature,
so let's go with that.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index c9df222e894a1..d60cd4379e866 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4514,10 +4514,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		if (!ret)
 			ret = hidpp_ff_init(hidpp, &data);
 
-		if (ret)
+		if (ret) {
 			hid_warn(hidpp->hid_dev,
 		     "Unable to initialize force feedback support, errno %d\n",
 				 ret);
+			ret = 0;
+		}
 	}
 
 	/*
-- 
2.53.0



