Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5964BA9F1;
	Mon, 31 Aug 2026 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184924; cv=none; b=gM7wESOqWCVauNhSF0yEw2kWX/BuKGxjy/7FiFvNF2/rTJanREb6RWT+PnbrQ44eVOaCtoAeRRVTEnv03dPCuqA/UruYoakOV51ocQX/pWKIBxxXAIVD4OL/+SlFnfOs9mL0Kud8htU5KZfnuzx/XssuItFYR55GDlHXAMPqiWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184924; c=relaxed/simple;
	bh=NBICjH1523uz50rfI/GUWN8WwtuRaTqSmMx2ZWmbboY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv0dffgXN6hzUpQAwyyfPva+ihfszRE+oompI0a2tUfEEsEGz/TFtevoc5ziFHbiD7zDST8+6HinkXHOVR553Osz1J9kKl6TD2CRsNLfncPqRRutkvsG9mCoIQ8Vq5udN7HXZzE2EHFwz87smoke/GSOJJwELDne0m0j8A15XtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uasbM2hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uasbM2hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E2C1F00A3D;
	Mon, 31 Aug 2026 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184922;
	bh=KM4ToLMkOICjCSZ4eN+pK9DEkHx/gXa9H4hcX64KWS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uasbM2hzRg5nbKgk4OiQg3d450x2s8l0dGYC68IGVJOupAMk2JOjcjyesb207m2h8
	 yvlFQ5UqnAdaQNM3Q+igDj2oqWyhHWJIbC7Aa01hfAcI5D9g9I6GFlYDwkQfqy6NVX
	 LyGA0q3OSart4QObnyzgFRp+09PFbM0DKnoCAAVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 84/92] Bluetooth: hci_core: Fix hci_conn_hash_lookup_cis
Date: Mon, 31 Aug 2026 15:35:22 +0200
Message-ID: <20260831133403.861272128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 50efc63d1a7a7b9a6ed21adae1b9a7123ec8abc0 upstream.

hci_conn_hash_lookup_cis shall always match the requested CIG and CIS
ids even when they are unset as otherwise it result in not being able
to bind/connect different sockets to the same address as that would
result in having multiple sockets mapping to the same hci_conn which
doesn't really work and prevents BAP audio configuration such as
AC 6(i) when CIG and CIS are left unset.

Fixes: c14516faede3 ("Bluetooth: hci_conn: Fix not matching by CIS ID")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1192,11 +1192,11 @@ static inline struct hci_conn *hci_conn_
 			continue;
 
 		/* Match CIG ID if set */
-		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.cig)
+		if (cig != c->iso_qos.cig)
 			continue;
 
 		/* Match CIS ID if set */
-		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.cis)
+		if (id != c->iso_qos.cis)
 			continue;
 
 		/* Match destination address if set */


