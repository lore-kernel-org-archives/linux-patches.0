Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC99E386454;
	Tue, 10 Mar 2026 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141172; cv=none; b=WwVE58b6YzhPi/DKyRHU+N1PTeAtwM/nsbIuDzYetK3S9U12GcNTj8cMPjncThw8cK7mw5k7vfSLFwHgMRJY7JXOcEFMdOToI8lw4QQC4wrXCCpUi4O4hbmGtvFJ8SFMmBAVQu36iyQ1sfjSnPs8YZBHaYjVKCj1xIsiAK5sdUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141172; c=relaxed/simple;
	bh=ZijnZwtCQR666sjH9IADWxAai2owMT2vgRdSuxyVNtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJfl7HetohTQhbe/MiuOgZ5hDWUQ65HNkHVvToqSI805JbKCcGAQIgh857M8BLfNFiWGuUu1Q5Vywpj6g+J+G3WfYreQPlDli5hV8ZgwZAytpzkyP/Ev1iWGv5DH1Hqsz+qHSUB2L6FoODTaPuaXvYCFxJ0nOnxB5REQjUX/FLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L429adZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L429adZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE9FC19423;
	Tue, 10 Mar 2026 11:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141172;
	bh=ZijnZwtCQR666sjH9IADWxAai2owMT2vgRdSuxyVNtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L429adZZ+oOk8mhYF4/0EAirUnd0AbsJoz11xgB24bH2HNgAhJTdVLiJRet91Njpw
	 sm7bAAEQqcngcWQzB8/vCe4i2z4bLrJX2Qhk2jPn2YsiKZ7kdgI7v+WsivOPDyFbKj
	 zO8cs+QlABChCpFoEwVo0j005gWS9jYFKJ4R2Okk+Eh8Uo+tLFDi2qiky+PPKY7s2b
	 e2w4+pT/WosfjbjkWWrkRYP2ry/K8DwRMRvuXxFiOFcu6JVDTJ2PcpIR9Cc15BShIw
	 VUm7tSVzQsCepEfIC6AVumNotQ8nukPSJza5AS1lE/cD/pOTVTMiqxIfDpQkwiuITR
	 XqYmqTprjrgSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mariusz Skamra <mariusz.skamra@codecoup.pl>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 173/311] Bluetooth: Fix CIS host feature condition
Date: Tue, 10 Mar 2026 07:03:40 -0400
Message-ID: <f2f4e46a237206a3e23a3b07f4cf7163476f7cbd.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mariusz Skamra <mariusz.skamra@codecoup.pl>

commit 7cff9a40c6b0f72ccefdaf0ffe03cfac30348f51 upstream.

This fixes the condition for sending the LE Set Host Feature command.
The command is sent to indicate host support for Connected Isochronous
Streams in this case. It has been observed that the system could not
initialize BIS-only capable controllers because the controllers do not
support the command.

As per Core v6.2 | Vol 4, Part E, Table 3.1 the command shall be
supported if CIS Central or CIS Peripheral is supported; otherwise,
the command is optional.

Fixes: 709788b154ca ("Bluetooth: hci_core: Fix using {cis,bis}_capable for current settings")
Cc: stable@vger.kernel.org
Signed-off-by: Mariusz Skamra <mariusz.skamra@codecoup.pl>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ iso_capable() => cis_capable() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 334eb4376a266..80b601e344ae3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4564,7 +4564,7 @@ static int hci_le_set_host_feature_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_host_feature cp;
 
-	if (!iso_capable(hdev))
+	if (!cis_capable(hdev))
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
-- 
2.51.0

