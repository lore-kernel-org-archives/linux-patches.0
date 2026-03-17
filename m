Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FD232548B;
	Tue, 17 Mar 2026 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768336; cv=none; b=Gx7cEZNKPtPsbNiy8OlFiVjflFJMS1XZrAYtrpK6yoEb5HMHvU8ZVQTpstIrojCpWSxj/986LCV3zmaa1kLTQA3tiUmM5TaimIEIMxAAkvxRTHZXdsboMlD+Hyz8Ie1yjtKzBVbePeXJBhoxUoJWxX1NaFoys8mnjf5Od4uk75c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768336; c=relaxed/simple;
	bh=PnJ4rbtCB/1SpVuq2dWbomq3j4yUyYr1j3gXx45fzIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsKMSJKq3mwGrA39SaUilOtwP/kG71egUmEXHRGvETCydrXUXWkzSll2cPNHmFXiHTaEWgCgLAKHXFsyCSus0Zurx26xEfh+SHPL40a8ZRu9V0KlLHC78KKr4NzDuQYrf2Sptt2mM0bjqOd3xDLhfldv3pY+Y4TtbLnnauNQYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTqzvWQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTqzvWQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BD1C4CEF7;
	Tue, 17 Mar 2026 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768336;
	bh=PnJ4rbtCB/1SpVuq2dWbomq3j4yUyYr1j3gXx45fzIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTqzvWQ32qLAzXq+a1m8d0cK56H6Sg/sYXwToAPE7KaDmzM/66PFrNw/lsfA6h0Uq
	 i1uJXhgBfu71dGp6bytiaHkA1jyf7KFpD9IhL4yY4H1SzFP0sWPN9NtrttOnfzazmx
	 dDscebRh3gG5YAKzMbiR2v8mNnySy5luSAF26JYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 243/333] smb: server: fix use-after-free in smb2_open()
Date: Tue, 17 Mar 2026 17:34:32 +0100
Message-ID: <20260317163008.375772562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

commit 1e689a56173827669a35da7cb2a3c78ed5c53680 upstream.

The opinfo pointer obtained via rcu_dereference(fp->f_opinfo) is
dereferenced after rcu_read_unlock(), creating a use-after-free
window.

Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3625,10 +3625,8 @@ int smb2_open(struct ksmbd_work *work)
 
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
-	rcu_read_lock();
-	opinfo = rcu_dereference(fp->f_opinfo);
+	opinfo = opinfo_get(fp);
 	rsp->OplockLevel = opinfo != NULL ? opinfo->level : 0;
-	rcu_read_unlock();
 	rsp->Flags = 0;
 	rsp->CreateAction = cpu_to_le32(file_info);
 	rsp->CreationTime = cpu_to_le64(fp->create_time);
@@ -3669,6 +3667,7 @@ reconnected_fp:
 		next_ptr = &lease_ccontext->Next;
 		next_off = conn->vals->create_lease_size;
 	}
+	opinfo_put(opinfo);
 
 	if (maximal_access_ctxt) {
 		struct create_context *mxac_ccontext;


