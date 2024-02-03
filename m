Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E49E10A0A;
	Sat,  3 Feb 2024 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933585; cv=none; b=des90LufNsCQHfE+nsJq4Ro3WnXH9ySYosB69eiEvvez/JOXbgj465WbtXNU7HXocJuOvSeKoes/G7lXUP4CaYjR+i9I5ydw/sRsd13y6roImTNo61HnNlLnPTV8O3n+eOGvzdQC0XMRdgFCE2H3l6tYSMANDbWJgsLai13qrSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933585; c=relaxed/simple;
	bh=LJaB3+PWvhTEZVQwnL0o2lpGrZxaa5ciZvfO0rNNOH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edmoiw3A+6pi0uCk367Yo69Q1/gB/wbGOVjbTkVKJJUJQV/TY3A0zHhm76toi2g88FsNnG/SjwVqKDPNmkrb1BACIxiunubFOJkOFNn4x6J/Cz2qYP3NvVy4ykek7nMSnh96gDSxwsXu0gZA4csTdQKS3lyJ886q9DGPh9T/CEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up9iXNT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up9iXNT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552F1C433F1;
	Sat,  3 Feb 2024 04:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933585;
	bh=LJaB3+PWvhTEZVQwnL0o2lpGrZxaa5ciZvfO0rNNOH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Up9iXNT46X7V6Pn+GO7ZKbwgAZN/GZbSneOYGlhgLR4TxgK5nZ2INquXjvo3IKF8r
	 lvu+0J79yDoVH0sAQSpEBXVM7PRDquFGxjD+5MmbPN7wejfwFolLiknoif92c9SRKP
	 QZacCDD5RAGJPdF3fUN2vL0KN6TJjSoEmhRWttqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	clancy shang <clancy.shang@quectel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/322] Bluetooth: hci_sync: fix BR/EDR wakeup bug
Date: Fri,  2 Feb 2024 20:04:04 -0800
Message-ID: <20240203035403.937973395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: clancy shang <clancy.shang@quectel.com>

[ Upstream commit d4b70ba1eab450eff9c5ef536f07c01d424b7eda ]

when Bluetooth set the event mask and enter suspend, the controller
has hci mode change event coming, it cause controller can not enter
sleep mode. so it should to set the hci mode change event mask before
enter suspend.

Signed-off-by: clancy shang <clancy.shang@quectel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9e71362c04b4..5c4efa624625 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3800,12 +3800,14 @@ static int hci_set_event_mask_sync(struct hci_dev *hdev)
 	if (lmp_bredr_capable(hdev)) {
 		events[4] |= 0x01; /* Flow Specification Complete */
 
-		/* Don't set Disconnect Complete when suspended as that
-		 * would wakeup the host when disconnecting due to
-		 * suspend.
+		/* Don't set Disconnect Complete and mode change when
+		 * suspended as that would wakeup the host when disconnecting
+		 * due to suspend.
 		 */
-		if (hdev->suspended)
+		if (hdev->suspended) {
 			events[0] &= 0xef;
+			events[2] &= 0xf7;
+		}
 	} else {
 		/* Use a different default for LE-only devices */
 		memset(events, 0, sizeof(events));
-- 
2.43.0



