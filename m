Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CA1DDCE;
	Tue, 16 Jul 2024 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145041; cv=none; b=MG4CcaxHnGgj07OXWvu/kANmBFW/82acqTnhR30vqdecYDwzqtP6AsXFtAXIhl7Ht+iDPQdUWVSzHy+owLWm5LrPok8z1xVyhxdOEU7qZXi0TIoVf4LJ5vpUeiQl+Mpa0QM3w/CVz86B2aWD55Bxvx93MU2bN9YxUwc9XrBFI0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145041; c=relaxed/simple;
	bh=8yCJzeFyyoRQ3EYeFUxNK3ewAeCtfJHdEYU/Bqaa414=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQb1oC2qqXQyF2LWNKWPs6CreG2V3XtGfZR21HXMW4NrZyKSjiG86SD0rE74jYNuJTNWcO5cdVVJjpiZMjimeUbWPVzp7/ZiGmPwdmVndKNmI40Y1trsb+xGhwHlRIRQIdBfoR33HdIeXlekAf2GbLD2SpImNuJSaNjKs/TJ5lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNB00FCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNB00FCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3A1C116B1;
	Tue, 16 Jul 2024 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145041;
	bh=8yCJzeFyyoRQ3EYeFUxNK3ewAeCtfJHdEYU/Bqaa414=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNB00FCVAVvPX1KcX6YFGkNvvlOQyKrW8HAXEOtmHKv27iUSW7gym085hs4O7RCJg
	 WLZZ2qFSJJ0klL7dzb97vtc2MUJO2BDELZuNqe10A0D89CuBEq35IdT9e721l0/1ex
	 AWjMEavhC1iNpbApEE1vTlKyDmqwk/9Do8XuDkdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 6.9 078/143] usb: core: add missing of_node_put() in usb_of_has_devices_or_graph
Date: Tue, 16 Jul 2024 17:31:14 +0200
Message-ID: <20240716152758.978208541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c7a5403ea04320e08f2595baa940541a59a3856e upstream.

The for_each_child_of_node() macro requires an explicit call to
of_node_put() on early exits to decrement the child refcount and avoid a
memory leak.
The child node is not required outsie the loop, and the resource must be
released before the function returns.

Add the missing of_node_put().

Cc: stable@vger.kernel.org
Fixes: 82e82130a78b ("usb: core: Set connect_type of ports based on DT node")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20240624-usb_core_of_memleak-v1-1-af6821c1a584@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/of.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/of.c b/drivers/usb/core/of.c
index f1a499ee482c..763e4122ed5b 100644
--- a/drivers/usb/core/of.c
+++ b/drivers/usb/core/of.c
@@ -84,9 +84,12 @@ static bool usb_of_has_devices_or_graph(const struct usb_device *hub)
 	if (of_graph_is_present(np))
 		return true;
 
-	for_each_child_of_node(np, child)
-		if (of_property_present(child, "reg"))
+	for_each_child_of_node(np, child) {
+		if (of_property_present(child, "reg")) {
+			of_node_put(child);
 			return true;
+		}
+	}
 
 	return false;
 }
-- 
2.45.2



