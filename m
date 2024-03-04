Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8D91EB5A;
	Mon,  4 Mar 2024 21:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589112; cv=none; b=lA0UK7DqIh17IdR402IsTQcA4FMKGfuFVwqz9gJYlFcEcTQHXjMhTHis8EUX+AKwcvIG0QG1mPGnCX0EtHF19lbiOi2kyaCKY5O2FYxeLhMscN22Megs2xXHWzR2Wj7gWClAp/XfSiKOCLyeJpkOZRZlroomE9REW5TxLljZO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589112; c=relaxed/simple;
	bh=PCt+01Yn/QBi+e8bAkiBXlqVQbBa3h2Nob2CmR6e12o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3DJTKigblxBsjFL0Uzbn1ltEAHFhIjyHj0QQGEIqy6tGjnlfaYm0/IqPY55QssJr5ufhBgJjO640C2SS1kSpROL/N29+qQHsn1IfNC1xD8GMzKtEVRH9htq6b07sIKmEkfE0fnQyOCEHPifH9xou+DeOpNvguXvb05jmoK+BXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mf2X8bdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mf2X8bdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A020CC433F1;
	Mon,  4 Mar 2024 21:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589112;
	bh=PCt+01Yn/QBi+e8bAkiBXlqVQbBa3h2Nob2CmR6e12o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mf2X8bdOq+6vtTFZxOR2RW0kd7DDSLf9tCbu5etfYI01yiaFJyE/Ip4jniHhd1Gbc
	 +8VjCKWxxMPiK1Khowu0duFD5E+fLZoTMlGR0XKaw7qIAOsf4YwMXvk0D4hGlwdFjU
	 K7KmwhXAMHWGxG4qerTSQJTtnuZByz82addzuc9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JianHong Yin <jiyin@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 179/215] nfsd: dont destroy global nfs4_file table in per-net shutdown
Date: Mon,  4 Mar 2024 21:24:02 +0000
Message-ID: <20240304211602.618924097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4102db175b5d884d133270fdbd0e59111ce688fc ]

The nfs4_file table is global, so shutting it down when a containerized
nfsd is shut down is wrong and can lead to double-frees. Tear down the
nfs4_file_rhltable in nfs4_state_shutdown instead of
nfs4_state_shutdown_net.

Fixes: d47b295e8d76 ("NFSD: Use rhashtable for managing nfs4_file objects")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2169017
Reported-by: JianHong Yin <jiyin@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8212,7 +8212,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	rhltable_destroy(&nfs4_file_rhltable);
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
 	nfsd4_ssc_shutdown_umount(nn);
 #endif
@@ -8222,6 +8221,7 @@ void
 nfs4_state_shutdown(void)
 {
 	nfsd4_destroy_callback_queue();
+	rhltable_destroy(&nfs4_file_rhltable);
 }
 
 static void


