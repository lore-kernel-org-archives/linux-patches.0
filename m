Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE7222D5C;
	Thu, 12 Dec 2024 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020132; cv=none; b=JdIZO5N2Fpd0+MP+wuHzRNFvrjLJb0TbiJ3qNUma/SxvYQotsmGR70UPycHDV89avq2Lrx/pgd71OCCizk0vurjvrXms4vqR94E5oc5m2WVvJQNlKxz8/J85jiNskvaDmGqbibGQfE4aT1LcaAd8v80A7QMePc1M2Tzb9Ji+N6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020132; c=relaxed/simple;
	bh=PTtb+hO0DMfuh9cu68HoYIiTx4jJXbSqeq5/EfsfgXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwtUm8yNELpvKjvpMSWAxIodRwB3XBSGHXEkVZXuNTzvuE3PQrgQ41cs7GOdaoF3e1X86V7By4Dz25VcflY1Kcx8zWl4gmBjRL2DfMX7fOvRUFtaFqEN5v6V3y5Ar5UCF66PegQ7aGCdOh1RQz1hYZx95l6Wq55v53iOFPo58us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMyODxOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMyODxOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1C1C4CECE;
	Thu, 12 Dec 2024 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020131;
	bh=PTtb+hO0DMfuh9cu68HoYIiTx4jJXbSqeq5/EfsfgXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMyODxOgbnCijOEBQ6XNoWXMmNU6NmEgGaOEM60M6e3xgvCXo7gd1ceBgAgoDBnpW
	 9BVgNmL3GpuXUyLd8Q1yk10hEh9RAyPVs7mHKhIIQyknGL6kEaH45yHRJkRZgCymf1
	 zz8xvG4mGoFR/pavbGmOrVwNiq+g6IO1qosvpysw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 6.1 384/772] driver core: bus: Fix double free in driver API bus_register()
Date: Thu, 12 Dec 2024 15:55:29 +0100
Message-ID: <20241212144405.778553125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


