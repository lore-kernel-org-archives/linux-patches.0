Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A333164C7;
	Sat, 25 Oct 2025 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409567; cv=none; b=Bx8cxYXu9q3NzUHQ5NpAcv6xKgSCswFpcb7QwwX+I5L2+m/DT2WJLckfxgeAWkx8zwKQUyckO4GvGOr5FoCV3cvDHW+s5pbe3H9BeKOl6x/QesDjJxHwyato8/68tRRFg0ieP7CloPgMj9SooxBXLA+g9P5zASycCeJNjrq/PrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409567; c=relaxed/simple;
	bh=fg9xU9MkRdWjXARbYA25O47bgzYDbgXcg3MEtfG4mJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sx/5ZnU6ZKoE1IOkRFUBFMM6ka9lXi9PpKX6YwFOgg2kcrMd0lWn+qHKA0K/GzCc4BtnC/TvUdxKvYRtVjoTJ6uIIFgqpfw7WVusMaQ7VUtLeF8HbEkf7d3AUyR6dIb6fF1UkPBaU0VdL6BRnYNRob8v2p2sMuJ2mIsscLvuGIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLGd3odE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLGd3odE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E64C4CEFB;
	Sat, 25 Oct 2025 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409565;
	bh=fg9xU9MkRdWjXARbYA25O47bgzYDbgXcg3MEtfG4mJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLGd3odEYpopEfv3acWnb7MEoVi7DuWXU41pJbH0oZSuLyR4vYhQUAoyjsHDwZkNh
	 rxutlpYPVdG2H0ObZv28CKl4VVBn/79DBQ4PhGSAqaDDWqVfc7UUCn4+dRBThOG7kJ
	 SU2O8Q8ij3SgG/hcgMa4e5ySiSfAnS2T4cm4EaHro/gfScnCqg8l/JlaVyMC7iZFeI
	 vv7+8vhrdk986JWPhBO8mRcCRjJySjgKpV83XXkopFjteYeNKoiBa6OApmCV2GZwQh
	 qAycSuWiVqlMrf50qqxLKtBFdCTpAxlhg2I8sLloxsVKFbqlzrQbB1oQ6PV5O9rc/0
	 sg0m7kUnayMGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] mei: make a local copy of client uuid in connect
Date: Sat, 25 Oct 2025 12:00:00 -0400
Message-ID: <20251025160905.3857885-369-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit bb29fc32ae56393269d8fe775159fd59e45682d1 ]

Connect ioctl has the same memory for in and out parameters.
Copy in parameter (client uuid) to the local stack to avoid it be
overwritten by out parameters fill.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250918130435.3327400-3-alexander.usyskin@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `struct mei_connect_client_data` and `_vtag` overlay input and output
  fields in a union (`include/uapi/linux/mei.h:44`,
  `include/uapi/linux/mei.h:90`), so once the driver fills
  `out_client_properties` the original UUID bytes are lost.
- `mei_ioctl_connect_client()` reuses the saved UUID pointer in its
  retry loop at `drivers/misc/mei/main.c:426` while the same call path
  overwrites the union with output data at
  `drivers/misc/mei/main.c:452`, so during the second iteration
  `mei_me_cl_by_uuid()` sees garbage and the ioctl fails with `-ENOTTY`.
- The patch copies the UUID into a stack variable
  (`drivers/misc/mei/main.c:672`, `drivers/misc/mei/main.c:700`) and
  passes a pointer to that stable copy (`drivers/misc/mei/main.c:708`,
  `drivers/misc/mei/main.c:750`), ensuring the retry logic added for
  D3cold link-reset recovery actually succeeds.
- Without this fix, user space cannot reconnect to the firmware client
  after a link reset triggered by powering a discrete card back up, so
  the bug is user-visible and regresses the very scenario the previous
  retry change was meant to solve.
- Risk is minimal: it is a self-contained stack copy with no API
  changes. When backporting, pair it with the `mei: retry connect if
  interrupted by link reset` commit so the recovery flow on stable
  kernels works end-to-end.

 drivers/misc/mei/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 8a149a15b8610..77e7b641b8e97 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -641,7 +641,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	struct mei_cl *cl = file->private_data;
 	struct mei_connect_client_data conn;
 	struct mei_connect_client_data_vtag conn_vtag;
-	const uuid_le *cl_uuid;
+	uuid_le cl_uuid;
 	struct mei_client *props;
 	u8 vtag;
 	u32 notify_get, notify_req;
@@ -669,18 +669,18 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			rets = -EFAULT;
 			goto out;
 		}
-		cl_uuid = &conn.in_client_uuid;
+		cl_uuid = conn.in_client_uuid;
 		props = &conn.out_client_properties;
 		vtag = 0;
 
-		rets = mei_vt_support_check(dev, cl_uuid);
+		rets = mei_vt_support_check(dev, &cl_uuid);
 		if (rets == -ENOTTY)
 			goto out;
 		if (!rets)
-			rets = mei_ioctl_connect_vtag(file, cl_uuid, props,
+			rets = mei_ioctl_connect_vtag(file, &cl_uuid, props,
 						      vtag);
 		else
-			rets = mei_ioctl_connect_client(file, cl_uuid, props);
+			rets = mei_ioctl_connect_client(file, &cl_uuid, props);
 		if (rets)
 			goto out;
 
@@ -702,14 +702,14 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			goto out;
 		}
 
-		cl_uuid = &conn_vtag.connect.in_client_uuid;
+		cl_uuid = conn_vtag.connect.in_client_uuid;
 		props = &conn_vtag.out_client_properties;
 		vtag = conn_vtag.connect.vtag;
 
-		rets = mei_vt_support_check(dev, cl_uuid);
+		rets = mei_vt_support_check(dev, &cl_uuid);
 		if (rets == -EOPNOTSUPP)
 			cl_dbg(dev, cl, "FW Client %pUl does not support vtags\n",
-				cl_uuid);
+				&cl_uuid);
 		if (rets)
 			goto out;
 
@@ -719,7 +719,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			goto out;
 		}
 
-		rets = mei_ioctl_connect_vtag(file, cl_uuid, props, vtag);
+		rets = mei_ioctl_connect_vtag(file, &cl_uuid, props, vtag);
 		if (rets)
 			goto out;
 
-- 
2.51.0

