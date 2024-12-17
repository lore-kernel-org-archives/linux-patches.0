Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1A41F8699;
	Tue, 17 Dec 2024 17:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455873; cv=none; b=WXntQ5eO2GKnpMT4yV5ld/zuday5xmy/WClGKuwrZhWKf9NE+HgrovE5T1j6pH/6ngTmC+AKVb1x2nX1su2v6sKBJe15jLucIWEznko8MNWg2TGQWrl82Rl10jszR9Frg/HFUyXCroJjzZZsIGXyE8QtqQ2AsW+xbbBZBKmZZp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455873; c=relaxed/simple;
	bh=FrhY7ZdWvY81D3LlT+/UU0IdGj3+v42MbRd0bKFagb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWI3KJQlmiu/6WOkkdY4oi25dZ/HuTafNMPvU3G44LEif8X0H0WPQ4OiUWp45jjkdO/mIDI+HXBrekc5BOUj/jhSWelm4pg8UDtZ1TGbFGc/tvPGPtktAg0jfz3Ub8VR5Yc00yakg06ZhGrXWT0mzdL8Km+Qjz1Rez+qDAfIhKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv4FUQT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv4FUQT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C46C4CED3;
	Tue, 17 Dec 2024 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455873;
	bh=FrhY7ZdWvY81D3LlT+/UU0IdGj3+v42MbRd0bKFagb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv4FUQT1WGaWwQrXXVN32UJeO1U4Pai6NNuUc27xgU6d1Nhgb5FIng8RkwrDfkYqW
	 frkg/1xg1kFWANT9WutsTX/SoybSMTrmsRwOLZleRMEJTZsJHy1qO5PQIH/1COtyz6
	 mQMfoT16ZbL/fRaJR72A55FPPTmD3pnwKcyYN1ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 62/76] ACPICA: events/evxfregn: dont release the ContextMutex that was never acquired
Date: Tue, 17 Dec 2024 18:07:42 +0100
Message-ID: <20241217170528.871619882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit c53d96a4481f42a1635b96d2c1acbb0a126bfd54 ]

This bug was first introduced in c27f3d011b08, where the author of the
patch probably meant to do DeleteMutex instead of ReleaseMutex. The
mutex leak was noticed later on and fixed in e4dfe108371, but the bogus
MutexRelease line was never removed, so do it now.

Link: https://github.com/acpica/acpica/pull/982
Fixes: c27f3d011b08 ("ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Link: https://patch.msgid.link/20241122082954.658356-1-d-tatianin@yandex-team.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evxfregn.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index 0a8372bf6a77..6fa6b485e30d 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -201,8 +201,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 			/* Now we can delete the handler object */
 
-			acpi_os_release_mutex(handler_obj->address_space.
-					      context_mutex);
 			acpi_ut_remove_reference(handler_obj);
 			goto unlock_and_exit;
 		}
-- 
2.39.5



