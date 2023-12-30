Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1E879DE;
	Sat, 30 Dec 2023 12:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8+Rc+yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88F8C433C7;
	Sat, 30 Dec 2023 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937829;
	bh=vVZM2edzuQ0AIa3t47Ggx3IWGEOrLvjo/f6K8C0gx0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8+Rc+yuyGsKdafzuXnN/pO6fmfFB04z3ZtUGtbr1FjXk8j9iPQcUBqUnpIJ4fk7I
	 Ul2KYcCkfWV9FDIK7sg0u7S7IZqBEjZ4reYoysZPGF8DBB6/UusHco35ydSUclaJW9
	 d8B3ZZUs4DrQYAA8Rahn2JSrVS+yl6jOEUFkKHrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/156] Bluetooth: hci_core: Fix hci_conn_hash_lookup_cis
Date: Sat, 30 Dec 2023 11:58:28 +0000
Message-ID: <20231230115814.104340312@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 50efc63d1a7a7b9a6ed21adae1b9a7123ec8abc0 ]

hci_conn_hash_lookup_cis shall always match the requested CIG and CIS
ids even when they are unset as otherwise it result in not being able
to bind/connect different sockets to the same address as that would
result in having multiple sockets mapping to the same hci_conn which
doesn't really work and prevents BAP audio configuration such as
AC 6(i) when CIG and CIS are left unset.

Fixes: c14516faede3 ("Bluetooth: hci_conn: Fix not matching by CIS ID")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 7fa95b72e5c85..22ce39a2aa7bc 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1227,11 +1227,11 @@ static inline struct hci_conn *hci_conn_hash_lookup_cis(struct hci_dev *hdev,
 			continue;
 
 		/* Match CIG ID if set */
-		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.ucast.cig)
+		if (cig != c->iso_qos.ucast.cig)
 			continue;
 
 		/* Match CIS ID if set */
-		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.ucast.cis)
+		if (id != c->iso_qos.ucast.cis)
 			continue;
 
 		/* Match destination address if set */
-- 
2.43.0



