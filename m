Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657FB1E51FA;
	Mon, 23 Jun 2025 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713920; cv=none; b=Nt4wib4DyomI2YEX3VBDPKZhrVaUCLUs9fv3bQ6dhHK7QgPDRgPimbPMdUoHZP7sOg1j/VSZ2nUYAZSPeWA0PQ9QoiLOP8MhRZyqdP4sPLp1gBQHtu0dhCp0dXyPk/eUrMBdhEgV3qGm3gBScSh96/wbjr8RC8OSKOfUoKlANAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713920; c=relaxed/simple;
	bh=3CSfZOx3ZlZwjEHyjFeBdevzNHXBJ1A86K2D9LdPgR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvFC/zp6omFy2Z27jjxGe/nwBFIQe+iMWS3eUP/orgCWSdMNne7wrQoTmD67OrFrEzaohAQWkDjrMTuIDKPAMRX3QyYQ+U0tXl755FQfsCBk//2eNE30rcRicLkMzrkGXgIoF5KGgbB92+Z6oiwcKcg3TICSvXhFABhf/o2JgnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyC0sk8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyC0sk8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF468C4CEEA;
	Mon, 23 Jun 2025 21:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713920;
	bh=3CSfZOx3ZlZwjEHyjFeBdevzNHXBJ1A86K2D9LdPgR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyC0sk8ikBR8uBxGn2a0e1T54w2fJ64gh7mm/OMKKElTD5z+y4pt/R2loP5Ay7ZE0
	 qnOh36iMoOfZHnfFUW6NrD/KB4sQsNSdAYNmzE7kMNq2JK9QJgMH6iy3H6k5T6Nyh1
	 D/mIDwO4fkUTDa2DZc1BbiQGt01ookNHyJgMUCvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 103/290] cifs: update dstaddr whenever channel iface is updated
Date: Mon, 23 Jun 2025 15:06:04 +0200
Message-ID: <20250623130630.058312482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit c1846893991f3b4ec8a0cc12219ada153f0814d6 upstream.

When the server interface info changes (more common in clustered
servers like Azure Files), the per-channel iface gets updated.
However, this did not update the corresponding dstaddr. As a result
these channels will still connect (or try connecting) to older addresses.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -485,6 +485,10 @@ cifs_chan_update_iface(struct cifs_ses *
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
+
+	spin_lock(&server->srv_lock);
+	memcpy(&server->dstaddr, &iface->sockaddr, sizeof(server->dstaddr));
+	spin_unlock(&server->srv_lock);
 }
 
 /*


