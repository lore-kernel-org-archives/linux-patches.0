Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342F91F756B;
	Tue,  3 Dec 2024 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237590; cv=none; b=m3SD5C8Yi2MyEKAZWV1GJbwhvnsv6/Khjt/NUc46NgOMzPkCFjbwh3UuBy9I4msGDnuMr/HFy2a3RF/AGfymmkSHHIQ0f3CF5/XfkCpLZHbNLlIgJVS+HzJ88QMwqoCx/Dp7gq9Sa7D6SG3z8VkxdU0A5EP8VTFl977uWthg8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237590; c=relaxed/simple;
	bh=UtF1oY/c68L4phgDdxUPyVjohgjzHYqn1pLCcXFe1Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAVKugVZ6LuyQXJYawqHgpmGsGrj7tFlH3AwLd7UzjrHnRuLF27LJ3KbRMG6B2vIcmCATV0YVvj/I1CEs7NpxLy/bspto8LEZVjsmLkRZrafmeBl78W1SK96V1n0i0hnxFitNNBmrzHMQvyFRMCJL1UUrlFmtG22zKC2PQzCJMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9lhdWxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9lhdWxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED00C4CECF;
	Tue,  3 Dec 2024 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237589;
	bh=UtF1oY/c68L4phgDdxUPyVjohgjzHYqn1pLCcXFe1Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9lhdWxqkgOMqTcwmFZnv9toJ2tXQgq7Wsow2at5lDMDom9Di1skNfWldo7gKbabK
	 YkPW471Ty3UBRCofISG1kWBYHH32KeAsQoD6WZy++jx0oeBYsezV9DtmZtSE+LcBi0
	 32EK12nhTeAHI3Zs6tofKKrAGtpP8FK+/PfteK9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/817] usb: typec: use cleanup facility for altmodes_node
Date: Tue,  3 Dec 2024 15:33:06 +0100
Message-ID: <20241203143956.194272172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 1ab0b9ae587373f9f800b6fda01b8faf02b3530b ]

Use the __free() macro for 'altmodes_node' to automatically release the
node when it goes out of scope, removing the need for explicit calls to
fwnode_handle_put().

Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20241021-typec-class-fwnode_handle_put-v2-2-3281225d3d27@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/class.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 1eb240604cf6f..145e12e13aef9 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -2293,7 +2293,7 @@ void typec_port_register_altmodes(struct typec_port *port,
 	const struct typec_altmode_ops *ops, void *drvdata,
 	struct typec_altmode **altmodes, size_t n)
 {
-	struct fwnode_handle *altmodes_node, *child;
+	struct fwnode_handle *child;
 	struct typec_altmode_desc desc;
 	struct typec_altmode *alt;
 	size_t index = 0;
@@ -2301,7 +2301,9 @@ void typec_port_register_altmodes(struct typec_port *port,
 	u32 vdo;
 	int ret;
 
-	altmodes_node = device_get_named_child_node(&port->dev, "altmodes");
+	struct fwnode_handle *altmodes_node  __free(fwnode_handle) =
+		device_get_named_child_node(&port->dev, "altmodes");
+
 	if (!altmodes_node)
 		return; /* No altmodes specified */
 
-- 
2.43.0



