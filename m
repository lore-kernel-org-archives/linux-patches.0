Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1E2DF9F;
	Tue, 20 Feb 2024 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465321; cv=none; b=KFIrMMRxfmeaAmJSP2cfO4CdIk0d3BPTRbj9Y2Xv/VqzXKCON/QN6wdp0Em47PDB8FtgFUwy+VlQLCc7t1if+Tm0z6laAeGk97lkCt9CUGoJKpRhXo2WGj7ljzd+/n8g6n4PDGV0eWt2NWuvQ8Z93oKm+fja21Gck3Iqu12iBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465321; c=relaxed/simple;
	bh=6aYNKFsXpFucHQcKRB68ce9DtgF5GUyfzqqJmOCYTKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFbZf7/hxUC1MynJQ4Zpfr/oiG9mW6NV9qULmgJRI5WDDrrOoisUyYMk5SAxRNLUhiq//MJ6DkTqk20lYrt2giolCJxROyP10kgyLyUuqbxd/LPlSALg+U7CeFWBmToLo1Tnb5Zod3lChpkkhZU9CXQUlqYWPe03n8him0Vz8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHtgkLhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHtgkLhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A552EC433C7;
	Tue, 20 Feb 2024 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465321;
	bh=6aYNKFsXpFucHQcKRB68ce9DtgF5GUyfzqqJmOCYTKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHtgkLhIeTgx+HlhrRXgedB1BLXR+vBnqPzGo7YhlSjWFxuyg5tmGAjHItzwGrhc4
	 kz89chANdw4ABssIpJiMXbBmQQQ7jLJo5CTJsQZkvKhZN80u5DymYZrUat3aQgdhKX
	 iub8X6ghE0n9zwNcH9bD4Mr6LeeoVAdsZzRLrOTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Mark Brown <broonie@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.7 306/309] usb: typec: tpcm: Fix issues with power being removed during reset
Date: Tue, 20 Feb 2024 21:57:45 +0100
Message-ID: <20240220205642.671214015@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 69f89168b310878be82d7d97bc0d22068ad858c0 upstream.

Since the merge of b717dfbf73e8 ("Revert "usb: typec: tcpm: fix
cc role at port reset"") into mainline the LibreTech Renegade
Elite/Firefly has died during boot, the main symptom observed in testing
is a sudden stop in console output.  Gábor Stefanik identified in review
that the patch would cause power to be removed from devices without
batteries (like this board), observing that while the patch is correct
according to the spec this appears to be an oversight in the spec.

Given that the change makes previously working systems unusable let's
revert it, there was some discussion of identifying systems that have
alternative power and implementing the standards conforming behaviour in
only that case.

Fixes: b717dfbf73e8 ("Revert "usb: typec: tcpm: fix cc role at port reset"")
Cc: stable <stable@kernel.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240212-usb-fix-renegade-v1-1-22c43c88d635@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4862,7 +4862,8 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		tcpm_set_cc(port, TYPEC_CC_OPEN);
+		tcpm_set_cc(port, tcpm_default_state(port) == SNK_UNATTACHED ?
+			    TYPEC_CC_RD : tcpm_rp_cc(port));
 		tcpm_set_state(port, PORT_RESET_WAIT_OFF,
 			       PD_T_ERROR_RECOVERY);
 		break;


