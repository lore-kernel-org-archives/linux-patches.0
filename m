Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462EF211493;
	Thu, 12 Dec 2024 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024327; cv=none; b=gmVdy1U5pS/KxHCohKLnnWgWCXBA87JSKCowcjhgQOCJsKP5Dvs4F+2pD6zRB+EXG4USQ8loJISpeoLpMGUp7UzNCo9/wr2rWii7el0tz2a6lwaOZ78DQWXh8w+a2aNvu04mkTYmnmvIFXHPzHu3hGxcvDVhpMXUNoc3S7bG6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024327; c=relaxed/simple;
	bh=/0NqUIomGTEqMap8TPmu4NfErR5UmDQ0mwh6yP2KXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJPWVouWMJ/GrS+YObFiav0aSq/RlF7Fjv2pIIOzbm2hfYjgmWTqMBu2cIjg2xx2FAvu5uJryzlMr9TIwARfQG8RFXmg+xX5N5bBVfHhy7xy22H+7bl8/vHb6mU6YPVCWaYxxuS/pUeXVnSSm7SeRUvi/FqiyhEOO1i46/kvw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mP5Qkdp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mP5Qkdp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96ACC4CECE;
	Thu, 12 Dec 2024 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024327;
	bh=/0NqUIomGTEqMap8TPmu4NfErR5UmDQ0mwh6yP2KXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP5Qkdp+1O+POxsTRd5gm5ldOvg0VtiJ7eCii4Ohrd6WXrl9qT30oR9XhpwOU04Sr
	 23Qg2mW5Cwbm4x81HFe1QmhyiY4pz6LdLzjUPI+rLUh6S3RJaly5L81RrQ345yOznf
	 kEZ0VnyAp6hLrqsYMpwZBOmgIXQPKWkHbuPE3bJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 5.10 260/459] driver core: bus: Fix double free in driver API bus_register()
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144303.868976790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bfa54a793ba77ef696755b66f3ac4ed00c7d1248 upstream.

For bus_register(), any error which happens after kset_register() will
cause that @priv are freed twice, fixed by setting @priv with NULL after
the first free.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240727-bus_register_fix-v1-1-fed8dd0dba7a@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Brennan : Backport requires bus->p = NULL instead of priv = NULL ]
Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -874,6 +874,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
+	/* Above kset_unregister() will kfree @bus->p */
+	bus->p = NULL;
 out:
 	kfree(bus->p);
 	bus->p = NULL;


