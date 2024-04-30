Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2A312DD83;
	Tue, 30 Apr 2024 11:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475541; cv=none; b=driDxkrHcE4ioKg0C7I6R2SFeEI8yDb0aBTlMNg9vLzVFuYNRjIVJQX69/r0/siXdLPZEiar3G9EZetnpa2VdI005gDT8z8Znk2IerRqV1/Qw++NHSmAKguBw9xz16u+a6x4/AixxYmBR+l09tH3y1zFgKHOFjjq2VHvWIgtLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475541; c=relaxed/simple;
	bh=vtSBKbfqeb9jakt4H+TxbMZDamK64PYHs+vcI2GbqNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDcLHHbQADb+UZBIWgFVKpmCFeIBvSuEFlz5dkuHzPLute8fjSOxUYx9ozoQw7K/104sluvHefXSOkM54wDAQBW3U46R0riugJ3/Aaz7JDII73NgFbuoLMHTT5hzfRITU0z7ErEKocZ8lNiS8ogEdbXCmImj9uhU549i4XvT5Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR4SzCIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR4SzCIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A820C2BBFC;
	Tue, 30 Apr 2024 11:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475541;
	bh=vtSBKbfqeb9jakt4H+TxbMZDamK64PYHs+vcI2GbqNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR4SzCIHRib7yGrcB5Vcm8LQy6dlpDEDSPpKx28mEL33G/h6/1ZIjkBFJrfWZQwQB
	 /D7eU+059JsaZUSORPZ0NiviEI0yOJ1Lb6BVf5vG1NK1+GzUB8dgCfBxB8KPaED/0/
	 437mkwZVj7Spdl4lDSm9GWDY6SVCKUlCNJ52/Z0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 128/186] smb3: missing lock when picking channel
Date: Tue, 30 Apr 2024 12:39:40 +0200
Message-ID: <20240430103101.747949481@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit 8094a600245e9b28eb36a13036f202ad67c1f887 upstream.

Coverity spotted a place where we should have been holding the
channel lock when accessing the ses channel index.

Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1057,9 +1057,11 @@ struct TCP_Server_Info *cifs_pick_channe
 		index = (uint)atomic_inc_return(&ses->chan_seq);
 		index %= ses->chan_count;
 	}
+
+	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 
-	return ses->chans[index].server;
+	return server;
 }
 
 int


