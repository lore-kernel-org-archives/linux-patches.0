Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2C55E4C;
	Tue,  9 Jul 2024 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524756; cv=none; b=gfyWGxe3cDF5N8qUsid3O/XmE2T8mO4fDo7dt0psW9t3XnEGgSwkRqbY+UWVNcqHa0svUQbMU8GTGz6MmXT09vZBgZTDNsGQ4EYAP5Ymy70BcKB4+mfKAxAHeGWIXAagR29BL4uOXBbT3T1BISWwFV1kzqGPJjoiGlUnedIhSd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524756; c=relaxed/simple;
	bh=QQXxT/MVntbce6F8DQIYSBChsPY9zR0WHXGFqUcnyOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9atXkdBMXuDnF/E6ArbmLbqwx+7grzWBossl7xrdhxFn1XLXLKWWMRO4DiqUXpBAkQanOKUIfiq58hYmhRBVdOI5OMwEMmN7GWh9SoZb2tXi7AnmPRqWfAqvBRcy8QCGM+q3z0zAThIcs592aRDYf2GnJ/92uRqCBRKfDzqJWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3EYv1En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3EYv1En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD358C4AF0A;
	Tue,  9 Jul 2024 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524756;
	bh=QQXxT/MVntbce6F8DQIYSBChsPY9zR0WHXGFqUcnyOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3EYv1EnG2XexBStDzqoIn0MUdx9namCn3c8dUZGaqHvY6r/6Pvx9qlibByJjhkpW
	 /+C9NCaGHTvVbcsluuUU7/SEwcP4HcKJ5fcptNpHup7yauVkF+Q75AHFsz57ki8eYA
	 5/bK/G/+DjTM3puAs+0iQZCBNrOINj0GVQ30f1Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/102] mlxsw: core_linecards: Fix double memory deallocation in case of invalid INI file
Date: Tue,  9 Jul 2024 13:10:23 +0200
Message-ID: <20240709110653.717837381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 8ce34dccbe8fa7d2ef86f2d8e7db2a9b67cabfc3 ]

In case of invalid INI file mlxsw_linecard_types_init() deallocates memory
but doesn't reset pointer to NULL and returns 0. In case of any error
occurred after mlxsw_linecard_types_init() call, mlxsw_linecards_init()
calls mlxsw_linecard_types_fini() which performs memory deallocation again.

Add pointer reset to NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b217127e5e4e ("mlxsw: core_linecards: Add line card objects and implement provisioning")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20240703203251.8871-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 83d2dc91ba2c8..99196333d1324 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -1484,6 +1484,7 @@ static int mlxsw_linecard_types_init(struct mlxsw_core *mlxsw_core,
 	vfree(types_info->data);
 err_data_alloc:
 	kfree(types_info);
+	linecards->types_info = NULL;
 	return err;
 }
 
-- 
2.43.0



