Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E2676C9C;
	Tue, 20 Feb 2024 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463742; cv=none; b=ETK8Wu4JnNB0dwn0JKmyUmoNF35+9jJurf+m0QGRr140MzvD+iCO+luLVAa38WMpM7BJlDJjDwz5Y3gYjRsOXjnP19A6aNLs/hs6JYcacNiUzqcy4FLwHQiyysh5vl+oxRbHCm5C820WVaAYXGh3E9ufhzO0V3HcrQQ8Mredzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463742; c=relaxed/simple;
	bh=OlWqrSwXG+xP/5ITWM1Jnm5BQWf855nCOmVkMJwQRZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBYb9QnPPujPBA/nllBwdJs76LZLCsc7cOc74mJ+M0YXhbmhQ3XeL37ZsQ82zIajBMcTtZ8y1dDuluKTHbgR+XO4+AnpnOmjO7bSZZFErE5hR26DedUGHFD+KVz/3Z8HAcZmzBBVeBgrAPdCj5+oBq1k+oulCtCrpArF/dhMpsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJuV6jCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJuV6jCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB742C433C7;
	Tue, 20 Feb 2024 21:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463742;
	bh=OlWqrSwXG+xP/5ITWM1Jnm5BQWf855nCOmVkMJwQRZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJuV6jCDo+d6H0iReYxm8O7ug2BpII0+bhqo0Uje+q0jM8YRW5d6aRJzVXHyCuBB7
	 zmjJiXFEen+puk34IMM/puN8yN0de698M2eOlPbuRZHAKUqf6IA9IZApKkv+VyIxkM
	 B5DKGAox9y60rKYaUCjnr/J8SpNlhoT/dCoezAkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Mark Brown <broonie@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 138/331] usb: typec: tpcm: Fix issues with power being removed during reset
Date: Tue, 20 Feb 2024 21:54:14 +0100
Message-ID: <20240220205641.897009452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


