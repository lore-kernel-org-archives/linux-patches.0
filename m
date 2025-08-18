Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03933A00C;
	Mon, 18 Aug 2025 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523200; cv=none; b=ovLnClFWmuilf4oxEZDkqJqjAGc42diREOp9ed9kPEDAln5VP7UJxgAcQi0ypTWnYSwjx27S2ArFJbxb2Nmu4MTYDH6cm+kgwZyktcmoPJGFUfBZNAXVlA+yoE8k76FE3sI0JLwkkfsLPszOcYvfvf/OP8Bvh/Gl3uatuE1xrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523200; c=relaxed/simple;
	bh=7QhmFEF2esKbmomH4UCkb6abT+ReG6Jn0jmiyvflsi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZo2spCFJm9ajrb8r5X2kcrUpfYFckuWSKUUiwL+7vBmel1BNB+5zNBXv9EZYvFb/F0FTB/7PjhbeTf2xH1eH1g3iv3SxkC8YVyusgTlM10dse66s9y28Q6QIDXHeOkq7Z2kzDxeoqJCsNF5cb2Rxrz+c2r/g3eWNnRNZX4AjIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnTV5neE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnTV5neE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F1CC116D0;
	Mon, 18 Aug 2025 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523199;
	bh=7QhmFEF2esKbmomH4UCkb6abT+ReG6Jn0jmiyvflsi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnTV5neEJNz7wMyIDwUaZb6wFZxNkkr7yo1aaOrIg4V24oPsF3JQDjRWRdb9AeO6c
	 YkEb6NiWF/YolD/p6GTLCUGSAguTjPXeBbkJSWyRxlqKaapRo5Ys0PPx4T5g+fE6Ne
	 QVpvi+6adE4LpEg1Av80vwZPq+9qnqy6DkTJJqHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 100/515] ata: ahci: Disallow LPM policy control if not supported
Date: Mon, 18 Aug 2025 14:41:26 +0200
Message-ID: <20250818124502.224669207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 65b2c92f69d3df81422d27e5be012e357e733241 ]

Commit fa997b0576c9 ("ata: ahci: Do not enable LPM if no LPM states are
supported by the HBA") introduced an early return in
ahci_update_initial_lpm_policy() to ensure that the target_lpm_policy
of ports belonging to a host that does not support the Partial, Slumber
and DevSleep power states is unchanged and remains set to
ATA_LPM_UNKNOWN and thus prevents the execution of
ata_eh_link_set_lpm().

However, a user or a system daemon (e.g. systemd-udevd) may still
attempt changing the LPM policy through the sysfs
link_power_management_policy of the host.

Improve this to prevent sysfs LPM policy changes by setting the flag
ATA_FLAG_NO_LPM for the port of such host, and initialize the port
target_lpm_policy to ATA_LPM_MAX_POWER to guarantee that no unsupported
low power state is being used on the port and its link.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250701125321.69496-9-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 931da4749e80..f52ae776d990 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1788,7 +1788,10 @@ static void ahci_update_initial_lpm_policy(struct ata_port *ap)
 	if ((ap->host->flags & ATA_HOST_NO_PART) &&
 	    (ap->host->flags & ATA_HOST_NO_SSC) &&
 	    (ap->host->flags & ATA_HOST_NO_DEVSLP)) {
-		ata_port_dbg(ap, "no LPM states supported, not enabling LPM\n");
+		ata_port_dbg(ap,
+			"No LPM states supported, forcing LPM max_power\n");
+		ap->flags |= ATA_FLAG_NO_LPM;
+		ap->target_lpm_policy = ATA_LPM_MAX_POWER;
 		return;
 	}
 
-- 
2.39.5



