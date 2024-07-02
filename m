Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4315218A;
	Tue,  2 Jul 2024 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941147; cv=none; b=kmOK9M06bZgFeDMjvtS3bOiQLv9qYRokfMA01S4lDWb7Dn8+CTXphAvBwdwvkcGk4pw30LoZdy924g9fqdBAvXQjUrWid3oP1/gk3zr8PxYONKa5imBRhtbIJUZi+m6zLK6q821CCX0xt0jeIpnYh3S7MrHdRLSDyg4/SENT0BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941147; c=relaxed/simple;
	bh=YSltllNot28m5zaJQ5h8Djg3vBtYsLIZGurjiQqyqSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT9mGgbgjD66nk57KZLzRopdsSWlKQ+/0zyrR4oVb6sTx0knOW4rCLXe2Apb2ap3PZrx0QX1xjyHiLRswRybtNkR8I5MEDPRhMtGqpR/ExX6iaL0ceGbisLgHGcZnCIxVA1zE44jpqf9f3srHd6gFiXpaKst1RQVjya3cqhnB1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJZnZ0/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJZnZ0/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61229C116B1;
	Tue,  2 Jul 2024 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941146;
	bh=YSltllNot28m5zaJQ5h8Djg3vBtYsLIZGurjiQqyqSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJZnZ0/x4eQ0WxaucDk6HyNlohrxpnFtDqMtxHLDag8jUJ2kR0Gn+3th/K3UKiEFD
	 SPywwDeXVhQUI7FQkkPbfyjZ7bHas1aTGzhoNTwkL4QZDPnYBJeG9sfAS4q4JZAFzs
	 3O6//QmMDCoxyHaUxkKjcBYDO9jWGZL8wnwyBZJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 111/163] usb: typec: ucsi: glink: fix child node release in probe function
Date: Tue,  2 Jul 2024 19:03:45 +0200
Message-ID: <20240702170237.258580044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c68942624e254a4e8a65afcd3c17ed95acda5489 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() in all early exits of the loop if the child node is
not required outside. Otherwise, the child node's refcount is not
decremented and the resource is not released.

The current implementation of pmic_glink_ucsi_probe() makes use of the
device_for_each_child_node(), but does not release the child node on
early returns. Add the missing calls to fwnode_handle_put().

Cc: stable@vger.kernel.org
Fixes: c6165ed2f425 ("usb: ucsi: glink: use the connector orientation GPIO to provide switch events")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240613-ucsi-glink-release-node-v1-1-f7629a56f70a@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -348,6 +348,7 @@ static int pmic_glink_ucsi_probe(struct
 		ret = fwnode_property_read_u32(fwnode, "reg", &port);
 		if (ret < 0) {
 			dev_err(dev, "missing reg property of %pOFn\n", fwnode);
+			fwnode_handle_put(fwnode);
 			return ret;
 		}
 
@@ -362,9 +363,11 @@ static int pmic_glink_ucsi_probe(struct
 		if (!desc)
 			continue;
 
-		if (IS_ERR(desc))
+		if (IS_ERR(desc)) {
+			fwnode_handle_put(fwnode);
 			return dev_err_probe(dev, PTR_ERR(desc),
 					     "unable to acquire orientation gpio\n");
+		}
 		ucsi->port_orientation[port] = desc;
 
 		ucsi->port_switch[port] = fwnode_typec_switch_get(fwnode);


