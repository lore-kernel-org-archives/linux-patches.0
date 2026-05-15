Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4283FF1DA;
	Fri, 15 May 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860472; cv=none; b=pFOkFO8ODgp1oIzsIV3aUCRCoUB87QubHN7nlAC4Iacig/mmuLx4exwS666fS5trTX2PlQXtDdmZMzlKbO/esqu93Z0ozKObje8OySd4LJpcliGrTZDxzOOmRSh5ZzJfpBxTTq8couzaCLlNi9oQjhfWBcMz64ANLhkaqiGJqM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860472; c=relaxed/simple;
	bh=N34cZGrpqKHG7w/IjlzadoJ/m7uJ6VRK1OcXRHx0R78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ6knhfzkMUCb5rfeh/qOvYCCrVLPUdcem5FXtVhvQvdna2y61xhzAqHOX1QXhpWUQb+SEbDWLsJIG1lw5gDVzUXAtb/uZlOClQN34nPYS8aWnlgtyDhxfQ0ytk2ZBwgIBxbZOaYZ2VTv3vQPF5fdjGk8HEdu19zGjXyAdSU/8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTTiU1+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTTiU1+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93202C2BCB0;
	Fri, 15 May 2026 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860471;
	bh=N34cZGrpqKHG7w/IjlzadoJ/m7uJ6VRK1OcXRHx0R78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTTiU1+TfQwUCXabz6wDsXZSZ/MWbrvObqHQU3JCsb0zGs1L+WFT1jWENPxiD5Fqg
	 MIu2lPyYqWRIOFHAwxcqyOcbE+dJ/tHcNyvIMA7fuJUuSGp8g2SheG7/VGcb1TYnun
	 sdUY7HtasN5pJ8mN5DsKH49IXhG0JQfDtF6Qzebs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 100/144] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Fri, 15 May 2026 17:48:46 +0200
Message-ID: <20260515154655.820659571@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ba9d20ee9076dac32c371116bacbe72480eb356c upstream.

When batadv_bla_add_claim() fails to insert a new claim into the hash, it
leaked a reference to the backbone_gw for which the claim was intended.
Call batadv_backbone_gw_put() on the error path to release the reference
and avoid leaking the backbone_gw object.

Cc: stable@kernel.org
Fixes: 3db0decf1185 ("batman-adv: Fix non-atomic bla_claim::backbone_gw access")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -723,6 +723,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


