Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EADC1F9EDC;
	Tue, 17 Dec 2024 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456835; cv=none; b=js/gtWJWrlNhr4ZPDef46JTcqpSZ/L14OtaLE05Fo2Tui9u7nJ9QmMI+kABE47FLVFmqZs+O8OyF54jcnoRsJRDQDJSlnB0kgZ2LXbjlTL2tQgD1dtNOzADDeDuvYwjHXz06V3O/Zy6m5Aztz1gbChdx6v0ql5tZh4qa/ittk68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456835; c=relaxed/simple;
	bh=5QYx/Z7PrJuNfdxD+fqxP6Bh8RA9haPBjAGZAq7aW/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anzKADCYNORTVlULkPNkr4rLqq2nj6p9QdAMfLLeGk2kW9r9kAdCoSQz2GxeFH7RCbNhVBZ7YvPnUERis19zpMgDLIBu1xJXYYRN9mulWUXxHkFFgesC5s3HkPv6wNdV+qvH3gkABKjML0VAzPcYYYgdPbxpSTP15ZbEFEaPOJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP8IpfdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP8IpfdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EDAC4CED3;
	Tue, 17 Dec 2024 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456835;
	bh=5QYx/Z7PrJuNfdxD+fqxP6Bh8RA9haPBjAGZAq7aW/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP8IpfdF+352auaufMt0lCk1nFzlj+9o38c3QuVix4dNxmfJWyz08DjzSl64NG9YS
	 0/S29ZcbTyT+dC+Samz6gnSCLlvWHZMJsiZuz86riNE4d3rBUvDf+3+z/Ao3MsrPzG
	 TpwCh0tkD7Z0v07TNtGCBdCv0b2LgR5EWlSk/mZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/172] Bluetooth: iso: Always release hdev at the end of iso_listen_bis
Date: Tue, 17 Dec 2024 18:08:24 +0100
Message-ID: <20241217170552.471014005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 9c76fff747a73ba01d1d87ed53dd9c00cb40ba05 ]

Since hci_get_route holds the device before returning, the hdev
should be released with hci_dev_put at the end of iso_listen_bis
even if the function returns with an error.

Fixes: 02171da6e86a ("Bluetooth: ISO: Add hcon for listening bis sk")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 7212fd6047b9..34eade4b0587 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1158,10 +1158,9 @@ static int iso_listen_bis(struct sock *sk)
 		goto unlock;
 	}
 
-	hci_dev_put(hdev);
-
 unlock:
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 	return err;
 }
 
-- 
2.39.5



