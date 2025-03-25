Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCBD26AA8C;
	Tue, 25 Mar 2025 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906190; cv=none; b=ePW1WAv8hZFEshZOnRnzrlNpaafa+1SRDR1jS310EtfXghXoNOQ1rMegM0FEP4iJYnqTswSSMg0MfmrzArYtUVcN7WkEFQlUTlWQwTAzhHHKA4c6gRFf8bt9M3x2UWJ7IBernoIjkrSfZAp2gv7L0jARni4eabGWSQfptKi0c/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906190; c=relaxed/simple;
	bh=xOJouAcBtkIOdsWUAmhr3NrWaQBTonN+++K+sNTZd9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfgqtjGzjEzf/BngK185zojp0IxQ2hRWbYWL84zejcc74ENdJPze5DB7LGUEArpkFrWp6EAx+b8oroGyOkF8Lbuea7R+pTi7glbP4RiOoq8QERUYNfEX+6gxy4nyYw8V5a8CbUvOGKafOhGTOt7xWJi8lKmgP2KvRV5w2KTGXRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tam6wi1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tam6wi1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA0FC4CEE4;
	Tue, 25 Mar 2025 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906190;
	bh=xOJouAcBtkIOdsWUAmhr3NrWaQBTonN+++K+sNTZd9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tam6wi1Vg/8PpAVdfAwIanIPtqLSSC0PYYX74HcXLPGtRsCJ9hZVIb+nqHRedKRur
	 kOXSJ63XhTWTTzsqsz2LpVPho2nSfnQO468FVqgXUqVTDm7TKQb5zPkHUE8XovOfe/
	 RLTENDMuMI53Wq9W5nDeTuzBvgwhsVBQCywq5p+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 36/77] regulator: dummy: force synchronous probing
Date: Tue, 25 Mar 2025 08:22:31 -0400
Message-ID: <20250325122145.297603209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit 8619909b38eeebd3e60910158d7d68441fc954e9 upstream.

Sometimes I get a NULL pointer dereference at boot time in kobject_get()
with the following call stack:

anatop_regulator_probe()
 devm_regulator_register()
  regulator_register()
   regulator_resolve_supply()
    kobject_get()

By placing some extra BUG_ON() statements I could verify that this is
raised because probing of the 'dummy' regulator driver is not completed
('dummy_regulator_rdev' is still NULL).

In the JTAG debugger I can see that dummy_regulator_probe() and
anatop_regulator_probe() can be run by different kernel threads
(kworker/u4:*).  I haven't further investigated whether this can be
changed or if there are other possibilities to force synchronization
between these two probe routines.  On the other hand I don't expect much
boot time penalty by probing the 'dummy' regulator synchronously.

Cc: stable@vger.kernel.org
Fixes: 259b93b21a9f ("regulator: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in 4.14")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Link: https://patch.msgid.link/20250311091803.31026-1-ceggers@arri.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/dummy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index 5b9b9e4e762d..9f59889129ab 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -60,7 +60,7 @@ static struct platform_driver dummy_regulator_driver = {
 	.probe		= dummy_regulator_probe,
 	.driver		= {
 		.name		= "reg-dummy",
-		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
+		.probe_type	= PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 
-- 
2.49.0



