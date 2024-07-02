Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C350BE5A;
	Tue,  2 Jul 2024 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940737; cv=none; b=bypFHhapZ2wSjcEMkggGTc7yZhBeJofiAwKpBSWCQ9xIPzGNaSDeDfcc6BesxALAtqHUtsG2WlvSPHQwob8KHNVMpi4+vM8slW+TT42DsDN5fc98VlKFzCfrur63G4XrsW5HUkfSdMVh5Poe5P8E0v+txH8CE4sXQdH2Z6x1v9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940737; c=relaxed/simple;
	bh=L+EZGDN7gk+k3pw9ptMFGBwZYpEfQqgcERHDHog9egM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYpNCEsso2I2zEhS/wHGJAHs2Do7PxOkKrtsMSmo9ndEVqYtXkBY6575Ku+TmAMmgwrNE9oWLCRep/Yl1hDlfQEWlqME6YjmCChMNlEukW2vc1SUw6/4cbynrXcJatUZQ7aJpWgUTD+coXxY4oIPo1woCxzN226Z9OXkfyeU7PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK3EWgSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK3EWgSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8093C116B1;
	Tue,  2 Jul 2024 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940737;
	bh=L+EZGDN7gk+k3pw9ptMFGBwZYpEfQqgcERHDHog9egM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK3EWgSrDk05jIIKQd/iIRDmAdUDpuXzPsLg+kHRdJWAqZXjIm2sgcGajO01jrMDG
	 Hq+e+PHY63vPbMRtl1MU7+9MgFW+3FYpjGFIL1zxMRPXuFHvcsQoWTxniGMihHmKPm
	 CGhffdenwtfTcIm8DZiPtfX3UJyxWR7Zs3ZpU3rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ammy Yi <ammy.yi@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/163] usb: typec: ucsi: Ack also failed Get Error commands
Date: Tue,  2 Jul 2024 19:01:58 +0200
Message-ID: <20240702170233.219641758@linuxfoundation.org>
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 8bdf8a42bca4f47646fd105a387ab6926948c7f1 ]

It is possible that also the GET_ERROR command fails. If
that happens, the command completion still needs to be
acknowledged. Otherwise the interface will be stuck until
it's reset.

Reported-by: Ammy Yi <ammy.yi@intel.com>
Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240531104653.1303519-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 9b0ad06db6dab..f6fb5575d4f0a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -153,8 +153,13 @@ static int ucsi_exec_command(struct ucsi *ucsi, u64 cmd)
 	}
 
 	if (cci & UCSI_CCI_ERROR) {
-		if (cmd == UCSI_GET_ERROR_STATUS)
+		if (cmd == UCSI_GET_ERROR_STATUS) {
+			ret = ucsi_acknowledge(ucsi, false);
+			if (ret)
+				return ret;
+
 			return -EIO;
+		}
 		return ucsi_read_error(ucsi);
 	}
 
-- 
2.43.0



