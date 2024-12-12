Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C692121B8E1;
	Thu, 12 Dec 2024 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022761; cv=none; b=ENCIENmXtlfxvAlZ1rYH5p/z6ITj//SPaUnptY5QKI/WDTpLBWM9Mstli5oak51zAfWnblDRh+rvr2XcECaEr0a72tPMCXhlIpPoXrF2kF20ZBQLg6pZttdJDoc6QZszKWyDGrRTInPzADmtiYilWnExqt3Psp7jEHii74tafpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022761; c=relaxed/simple;
	bh=tOTtHWGvurV6d+noyY4QIo4B/GrFjIMTTwbSSCwSYmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enSr85qHUdP4fMpSgcRzGv8yENfQVPc7A42UO7oyxu1DmA23IKnwxmo01cw/hax6zkh6Kj1oH0PpIgJwkOTnyll9RuJ5czeV11uLRXSXFK1z7tTQqglH64iaHH0ig7JkQ3nFknzgPjnkne2L04qNHk8ImtsuGbD2qA7RI/cdKX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLmUUw+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLmUUw+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD3EC4CED0;
	Thu, 12 Dec 2024 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022761;
	bh=tOTtHWGvurV6d+noyY4QIo4B/GrFjIMTTwbSSCwSYmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLmUUw+SD9nIPNbP0rLqlObzy9OBhpazCWfjtBD2bvJWMXn3EU6mhPvGzlqeVYDZc
	 X30d532A8D34kPSnjIcQGgMiSeSx9+UF26XkSalhFWOR7/CglDzso6zO4X6MgiFMEj
	 vZJjmb86DPD4Ol8/wyN3mgBWY+E3FxbTIor3lOhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 330/565] platform/chrome: cros_ec_typec: fix missing fwnode reference decrement
Date: Thu, 12 Dec 2024 15:58:45 +0100
Message-ID: <20241212144324.642242578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9c41f371457bd9a24874e3c7934d9745e87fbc58 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() upon early exits (return, break, goto) to decrement
the fwnode's refcount, and avoid levaing a node reference behind.

Add the missing fwnode_handle_put() after the common label for all error
paths.

Cc: stable@vger.kernel.org
Fixes: fdc6b21e2444 ("platform/chrome: Add Type C connector class driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241013-cross_ec_typec_fwnode_handle_put-v2-1-9182b2cd7767@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -375,6 +375,7 @@ static int cros_typec_init_ports(struct
 	return 0;
 
 unregister_ports:
+	fwnode_handle_put(fwnode);
 	cros_unregister_ports(typec);
 	return ret;
 }


