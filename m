Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06335328255;
	Mon, 13 Apr 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099453; cv=none; b=ERVE+38b+Izbs5kEU0PP/ZRmMws6usHUAuutwY01VTuYx0wjfDpNfJotOLQgb3wXmKTEqILaBtPQXWPVvc2PqIpr4CdqkIE646IJtf4DznrkDAB7DLWx6xqCPgwMFs0z4mM3Zbkkw7ifp/vxOS/UMkRoUM5t3sU093kWhuhAwYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099453; c=relaxed/simple;
	bh=dtULmERuCE3An5+Fg1e6cxY27HfzA7+0zIlmh66NZc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhC06FaAI+euPHgaW0ighDQawV3AtMwmtD9p9QoeYKin4dmrcXSzPhcdfU3xzw3TCxekppOaJwYSo8bwSJMCwP1PRr8r/F9MSRSA6ltAQ8pb+c43I6bdsabtoVuLlWUWpNHqq76NCGKeJemnctCv5SRMXR7VsnDICQObeBnr2KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvQ3w5/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvQ3w5/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F547C2BCAF;
	Mon, 13 Apr 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099452;
	bh=dtULmERuCE3An5+Fg1e6cxY27HfzA7+0zIlmh66NZc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvQ3w5/zzzooPQ5WNqi6o1ghihElYQQX+8FZyIwgmKFNiOwA96esmaym+0BBd6tNu
	 YWSEvOaciMDDaEaKj6Gr0VxwEwI8XQjnNTZc8vce75pkuiZQ2wvlL8qsCj59AbXwvA
	 q34QtXag5VZymf8TQ8naID31Io/mNQAcWa2YwioA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/491] Bluetooth: MGMT: validate LTK enc_size on load
Date: Mon, 13 Apr 2026 17:59:49 +0200
Message-ID: <20260413155831.917261071@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fda0bd990dcb7..b768abbf2b121 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5948,6 +5948,9 @@ static bool ltk_is_valid(struct mgmt_ltk_info *key)
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



