Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350F026FA5A;
	Wed,  8 Apr 2026 18:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673132; cv=none; b=lYqjHOeG2EJyt2NSbEhkGYaulDWfbqhkjPTqQroCeVm7UZKR6dYJ595f5/XiaEIMurn6kGEwFshSbyTz6wwTV1Ysp9w2wcjXosgnxgpCaaX6Uqw8BRvCz2j72bPWHZgVHfrt5bcb6lQYISDhskPdTYqESSnbRqrN1CB6mtU2yvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673132; c=relaxed/simple;
	bh=IsAsF0UnXXjdLxdVplsBUbNFoMoSXQfqq+dfsH+/xy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8uDUbYJTQqIfRe13atVIEow9mckJXlYMWVf2Vq/2A7CLQDLLYOADEwfCk/LR/4w6Yo4aQtu/jG+scN/pMIw7yqyEQmQ5wkrysHQMSirsHomU8lx7SjxoUMLsN0Mvxh70uFBGY7YQC9BhJcIZx6vfzLiG+e6lTQp6t5mmISie3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoV6Q9nJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoV6Q9nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0681C19421;
	Wed,  8 Apr 2026 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673132;
	bh=IsAsF0UnXXjdLxdVplsBUbNFoMoSXQfqq+dfsH+/xy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoV6Q9nJ4JU86cY32G0/V/WDxumrMLK0y+RIc9PCGXBKXbiyCfFAHmM18/3s7pgnl
	 r8okVKwj1gsvYZrzOlx1f8XRei5oatb3RrvVnleyYH731sDYKQrhZKHtChl9zzfb9V
	 xmM4Dm0lheLka6IDnlUXIGJjcXww9vOHpaLG0QJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/277] Bluetooth: MGMT: validate LTK enc_size on load
Date: Wed,  8 Apr 2026 20:01:06 +0200
Message-ID: <20260408175936.888806341@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit b8dbe9648d69059cfe3a28917bfbf7e61efd7f15 ]

Load Long Term Keys stores the user-provided enc_size and later uses
it to size fixed-size stack operations when replying to LE LTK
requests. An enc_size larger than the 16-byte key buffer can therefore
overflow the reply stack buffer.

Reject oversized enc_size values while validating the management LTK
record so invalid keys never reach the stored key state.

Fixes: 346af67b8d11 ("Bluetooth: Add MGMT handlers for dealing with SMP LTK's")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5d70b1f69bb6d..d3df358cbe139 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7166,6 +7166,9 @@ static bool ltk_is_valid(struct mgmt_ltk_info *key)
 	if (key->initiator != 0x00 && key->initiator != 0x01)
 		return false;
 
+	if (key->enc_size > sizeof(key->val))
+		return false;
+
 	switch (key->addr.type) {
 	case BDADDR_LE_PUBLIC:
 		return true;
-- 
2.53.0



