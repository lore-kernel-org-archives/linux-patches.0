Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530043D9031;
	Wed,  8 Apr 2026 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674469; cv=none; b=OiyWy2Q0wfUtCEBWQKsAUZLeuHbsbpU7arbY1+mRwA31Mn1KDgWNdhLss7KXosneU6Q5ZywV//69wFpcQ+y0jwmphkv4iBbNjs+y+X9Tn4cmQtkzcHLR3NJoi3Ut5SKtHqrLztPSBGYbAQC9DohUPd3Y/KMpv9Iyzj8xfbGftM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674469; c=relaxed/simple;
	bh=GgIbrIs453+fO3Ej1ZMwdAe9qYjwmS4EgPtxuPUONm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0oZydPfbDo0Kj3OTdwq6guagf7aZNwOsx0jpUF1xN5/iRnezkrmPL4WQr+qympUzmkzPCgQHAX5SViQMaZXmv4n3wR1jzIRsihmXvgVxAxCkq+KhYnpDf0JEAzsLbISLO7os5e/Tj5poOL479JdGX0J600A9I3Sy80M/mohnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhWLMCxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhWLMCxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA80C19421;
	Wed,  8 Apr 2026 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674469;
	bh=GgIbrIs453+fO3Ej1ZMwdAe9qYjwmS4EgPtxuPUONm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhWLMCxQaqnLMUBr/pJW2EaBwHjMs+9wgRyLCL30FqY5HmRJPk5cyGfhhYXKKsINl
	 C6sAOz2KosFXFg5/FAGUxTgWl/9fazqu72SOX221AqPkpvISXqPRKO2EuBQvlANTdQ
	 HfCHJa0cbXw1s/Hx04Zu2RhkLzTwpxfzI54dwqJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 102/311] Bluetooth: MGMT: validate LTK enc_size on load
Date: Wed,  8 Apr 2026 20:01:42 +0200
Message-ID: <20260408175943.223491949@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index f3da1bc38a551..996cef033e48e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7248,6 +7248,9 @@ static bool ltk_is_valid(struct mgmt_ltk_info *key)
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



