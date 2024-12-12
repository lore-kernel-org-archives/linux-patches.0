Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE79229677;
	Thu, 12 Dec 2024 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022846; cv=none; b=sZG2dOxz6anlFrhMimqjTWn09mucVHSfwkVMh5jPJZEwUls+aUQ6k7fC0R0JihSfWjkuX2+J2dtzpTkPAoAWahGK2yAVhRdgJhl1yYZ0i8EsA2u0GNww84PNJPzu+JucEuruisUohhMg14pVpBfU5+hjCQkBZ4V/3ibauVaow80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022846; c=relaxed/simple;
	bh=RxxfuOJejaqixWInRBor3+AfZTfQIMOS1tp20icg5hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkNxYE/OQarpTrdh6ID/6dFZWHqXbAYm3JoyuVrSOIBe9YvRXXtzD+lrRWkZKtqgiuq8bTxaG2l0t/LWMvPgcUB6PUyeAObpHF5fGt88X/MU9y8pX26kbzvtDU9TnKEcTG/tLe64vXT442uvW9U9DfbJmry7eV5/T+eQRXlZ4H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/Ao16UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/Ao16UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA4C4CECE;
	Thu, 12 Dec 2024 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022846;
	bh=RxxfuOJejaqixWInRBor3+AfZTfQIMOS1tp20icg5hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/Ao16UCgeh76Y8aNFCyJ2dcUl/J1tQVZePoFD5nC9ktrLCDpSzpSRlXEKkIzOcKq
	 OHcBf3Rh3rAVC6zD8QThLEywn/j5SzSzlF1rhVCo2OEbDUhmBDqrMSjY3coj6GGv0g
	 H7c4G6vf0zwv9PuUFSbtlltfSL5O3cbXwtfQm+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 5.15 321/565] driver core: bus: Fix double free in driver API bus_register()
Date: Thu, 12 Dec 2024 15:58:36 +0100
Message-ID: <20241212144324.291216840@linuxfoundation.org>
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
@@ -853,6 +853,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
+	/* Above kset_unregister() will kfree @bus->p */
+	bus->p = NULL;
 out:
 	kfree(bus->p);
 	bus->p = NULL;


