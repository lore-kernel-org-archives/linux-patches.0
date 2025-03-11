Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80362571D8;
	Tue, 11 Mar 2025 15:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706055; cv=none; b=ZFTovWm7bqeudIhHNFhRnZUguEpiKckuXcYifO5+VZzOGt4ymgG2UURxbZOtj102gP/Oor+7XpA6S9LrfYelbl8cP9sge+67lujBxjHmI2Y72S8MliAUhIXgBqTG2BU+TUfRFV3ZiGg7rzK3rxSMB/KrrxFrVjox0PUxcReykhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706055; c=relaxed/simple;
	bh=uSvEpiD/I0l8cXzaz6Pqwa67pK5weTx9Q50RPL2iioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe++SArnYWoFNKzWMBBgLlvM0dT7TtYlk6dOWC0X6U7c+5JlfzhE1s+iUtwSX7BTM/kouVn8NeFNd9SKiNkGGSKJBQU37Si1udxu3w01jZvOwiHV9XYyhILGv9FcHb3etrjxF+2Ve6BikDffUyNv+ZQt5M3hqX94eaj/fC7/9s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pae5mx5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pae5mx5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF2AC4CEE9;
	Tue, 11 Mar 2025 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706055;
	bh=uSvEpiD/I0l8cXzaz6Pqwa67pK5weTx9Q50RPL2iioY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pae5mx5FUTsXAuZvtcQwOczBMcaArwWVndPe1zkzqc9chrMAy7/qH5rr3UwsRybrK
	 UZQQG5YZ7NBS/W5zrl4spn6fetO9DmueSxQE8szJsJCe6SFx7Ch3h0IFEutJC3WDZI
	 dTIeDgRy/LSbnkcl9qMW9edXNawAYBFiUr9TK89M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 5.4 227/328] driver core: bus: Fix double free in driver API bus_register()
Date: Tue, 11 Mar 2025 15:59:57 +0100
Message-ID: <20250311145723.933789056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bfa54a793ba77ef696755b66f3ac4ed00c7d1248 upstream.

For bus_register(), any error which happens after kset_register() will
cause that @priv are freed twice, fixed by setting @priv with NULL after
the first free.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240727-bus_register_fix-v1-1-fed8dd0dba7a@quicinc.com
[ hagar : required setting bus->p with NULL instead of priv]
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -873,6 +873,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
+	/* Above kset_unregister() will kfree @bus->p */
+	bus->p = NULL;
 out:
 	kfree(bus->p);
 	bus->p = NULL;


