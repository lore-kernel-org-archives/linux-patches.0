Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B47D1F76D9;
	Tue,  3 Dec 2024 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239713; cv=none; b=Yg9+gHJRvn+r/YYajWZKaZ04rvd0c5CpRSM45bmFLjM2rzFi/rjkZDJFRcxa4smbyfujKdo55M8GbSflJ96iRZRPqbV+LkKwdwfpvSl3jt0m2zf1I+jBiVFbt/9GVfSFsBbA5NlDE3VQ/KmbDPvhtSysqzpeDqkA3fsYhWU/M24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239713; c=relaxed/simple;
	bh=ovkFelU5ByJE1dtBwQtlm7wo7bS8nYVihmFpPmNipPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT7MIaHEmQCF7II7dLY6X46/k28jGKXqkaTMBFVTL1W+crxT88h97HTvnEh1Zssx1Xr/EBzwYU/U8wenpkXCgANNwxrtMnPhgVMj+upJ8rMS1HtjKK1M2CgBvleEZmZGYL3IbZNacLx6+fxQngFZknxL9wnJ3zySVpItExkN/WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKApj8pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKApj8pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8930C4CED8;
	Tue,  3 Dec 2024 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239713;
	bh=ovkFelU5ByJE1dtBwQtlm7wo7bS8nYVihmFpPmNipPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKApj8pMZ3t3miNn1jOVFk0tqM0aXDA6tvzrrew38Cew8DnFxAgKWsxmARjOEBcvJ
	 jL74Shd08yaNvJkvFka1jntw3FtAMo9Wy/mUl1QKFanNC57Y7KWLUE8TUejLgDzwEc
	 OaOFg0ZwIfbLhR8bwDGrVT9hfw2JWXOmqpqpikOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.11 707/817] platform/chrome: cros_ec_typec: fix missing fwnode reference decrement
Date: Tue,  3 Dec 2024 15:44:39 +0100
Message-ID: <20241203144023.579711753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -409,6 +409,7 @@ static int cros_typec_init_ports(struct
 	return 0;
 
 unregister_ports:
+	fwnode_handle_put(fwnode);
 	cros_unregister_ports(typec);
 	return ret;
 }


