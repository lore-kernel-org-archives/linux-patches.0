Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8130566D;
	Fri, 15 May 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861827; cv=none; b=Uhwt0ONgZsfqKloiL0l4qOcmGi6Gva9f02ZVjoonF4a3qHC3xiroqsZmrjVwAXyT2xAibAEP5Z++0E8EoPYuvIDtpoeubqkOA98ZaxiXYZak75lTq13JgY+Z+6074lZt5onqX7SCrROR0tg03VL6I7osiLd/CXnGbkJih0U19qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861827; c=relaxed/simple;
	bh=y5pQb9S4uAaZ0klBtrlfz1v5A7+CpNkHXCo+U+GDxm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoR23NzHIJq/vczpjuv5qI40ip11Ob89dTT6NrDiAOORrDzj23jrhQbKD+wbp5o44NAJvRY5CCK/eQmIpFNx05rLOVNscZp6yIQkuIGFw+ywVOe4Z4J9tgG/WvsbesmvVxja0wCI80Ju0IntmBsfuV7jOWZi85S7CAEke+NMGpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwTYQfE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwTYQfE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5985C2BCB3;
	Fri, 15 May 2026 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861827;
	bh=y5pQb9S4uAaZ0klBtrlfz1v5A7+CpNkHXCo+U+GDxm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwTYQfE/nB5ShZKx3fUJ1QOKeL4nm7VL3QkaT0TJdqCa15TYtNvWnI8FjvP7Yy+rd
	 12NebvGX3ocMJ3/K1Y4rGfZP94V4VVAZ0MG9U9rAszPPxq+YlDNE35y+p22Gl8gd84
	 LAixyXAD9Ai5z3bRQaYdq6afTOUlNUyLVXdBM6bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 471/474] Bluetooth: MGMT: Fix memory leak in set_ssp_complete
Date: Fri, 15 May 2026 17:49:40 +0200
Message-ID: <20260515154725.297954202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

commit 1b9c17fd0a7fdcbe69ec5d6fe8e50bc5ed7f01f2 upstream.

Fix memory leak in set_ssp_complete() where mgmt_pending_cmd structures
are not freed after being removed from the pending list.

Commit 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs") replaced
mgmt_pending_foreach() calls with individual command handling but missed
adding mgmt_pending_free() calls in both error and success paths of
set_ssp_complete(). Other completion functions like set_le_complete()
were fixed correctly in the same commit.

This causes a memory leak of the mgmt_pending_cmd structure and its
associated parameter data for each SSP command that completes.

Add the missing mgmt_pending_free(cmd) calls in both code paths to fix
the memory leak. Also fix the same issue in set_advertising_complete().

Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1937,6 +1937,7 @@ static void set_ssp_complete(struct hci_
 		}
 
 		mgmt_cmd_status(cmd->sk, cmd->hdev->id, cmd->opcode, mgmt_err);
+		mgmt_pending_free(cmd);
 		return;
 	}
 
@@ -1955,6 +1956,7 @@ static void set_ssp_complete(struct hci_
 		sock_put(match.sk);
 
 	hci_update_eir_sync(hdev);
+	mgmt_pending_free(cmd);
 }
 
 static int set_ssp_sync(struct hci_dev *hdev, void *data)
@@ -6452,6 +6454,7 @@ static void set_advertising_complete(str
 		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
 
 	settings_rsp(cmd, &match);
+	mgmt_pending_free(cmd);
 
 	new_settings(hdev, match.sk);
 


