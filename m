Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314A151C44;
	Mon, 11 Dec 2023 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdL3ZcIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC87C433CA;
	Mon, 11 Dec 2023 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319743;
	bh=O8TtMAaHMXSq/9ASMljXoENnGItLO2lVUCLc1TmD5ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdL3ZcIplBMBdMpbaxpm6RonrDQevjYPsjmeM5b2V1d19ucWQGMp4fvJ/7F1YcV/F
	 CEJ3qJYNbzqSDEUw5YoWGKfccu8Mol8bq5Ud13f9A2ZGNJlvtAb4pCjrq7ZmQXjn+0
	 X/GZRv7/bZP3qP1dIk/3nVpm6ZmO6moDCMqdHnm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 218/244] usb: typec: class: fix typec_altmode_put_partner to put plugs
Date: Mon, 11 Dec 2023 19:21:51 +0100
Message-ID: <20231211182055.761638564@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: RD Babiera <rdbabiera@google.com>

commit b17b7fe6dd5c6ff74b38b0758ca799cdbb79e26e upstream.

When typec_altmode_put_partner is called by a plug altmode upon release,
the port altmode the plug belongs to will not remove its reference to the
plug. The check to see if the altmode being released evaluates against the
released altmode's partner instead of the calling altmode itself, so change
adev in typec_altmode_put_partner to properly refer to the altmode being
released.

typec_altmode_set_partner is not run for port altmodes, so also add a check
in typec_altmode_release to prevent typec_altmode_put_partner() calls on
port altmode release.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231129192349.1773623-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -266,7 +266,7 @@ static void typec_altmode_put_partner(st
 	if (!partner)
 		return;
 
-	adev = &partner->adev;
+	adev = &altmode->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -496,7 +496,8 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	typec_altmode_put_partner(alt);
+	if (!is_typec_port(dev->parent))
+		typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


