Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D522AE74;
	Fri,  5 Jan 2024 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcSWOhyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BF0C433C8;
	Fri,  5 Jan 2024 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465757;
	bh=SChJFmomsrz9DKl6mdPq1/cyxA8JrxrGzJFsXQJN6D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcSWOhyF5VXboWJ9p3kUz5ykQ+rIUmQxk4WolIUXOhccUlWrlodr9gWplEVQHeHwp
	 qVopVfUKu9NFGyOu7cvmVMiQvp+YI8dlQyunFFN6wVS5xbpg8rNowGJ5Fk7v16xHvF
	 /OPHRn8/r+gfHdJWr7s9Tv1ERgl2TTLEALmAX6OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Suvanto <markus.suvanto@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/47] afs: Fix dynamic root lookup DNS check
Date: Fri,  5 Jan 2024 15:39:03 +0100
Message-ID: <20240105143816.132286320@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 74cef6872ceaefb5b6c5c60641371ea28702d358 ]

In the afs dynamic root directory, the ->lookup() function does a DNS check
on the cell being asked for and if the DNS upcall reports an error it will
report an error back to userspace (typically ENOENT).

However, if a failed DNS upcall returns a new-style result, it will return
a valid result, with the status field set appropriately to indicate the
type of failure - and in that case, dns_query() doesn't return an error and
we let stat() complete with no error - which can cause confusion in
userspace as subsequent calls that trigger d_automount then fail with
ENOENT.

Fix this by checking the status result from a valid dns_query() and
returning an error if it indicates a failure.

Fixes: bbb4c4323a4d ("dns: Allow the dns resolver to retrieve a server set")
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216637
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Markus Suvanto <markus.suvanto@gmail.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index f4f2ab6d877f3..d06994990fc35 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -20,6 +20,7 @@ static int afs_probe_cell_name(struct dentry *dentry)
 	struct afs_net *net = afs_d2net(dentry);
 	const char *name = dentry->d_name.name;
 	size_t len = dentry->d_name.len;
+	char *result = NULL;
 	int ret;
 
 	/* Names prefixed with a dot are R/W mounts. */
@@ -37,9 +38,22 @@ static int afs_probe_cell_name(struct dentry *dentry)
 	}
 
 	ret = dns_query(net->net, "afsdb", name, len, "srv=1",
-			NULL, NULL, false);
-	if (ret == -ENODATA || ret == -ENOKEY)
+			&result, NULL, false);
+	if (ret == -ENODATA || ret == -ENOKEY || ret == 0)
 		ret = -ENOENT;
+	if (ret > 0 && ret >= sizeof(struct dns_server_list_v1_header)) {
+		struct dns_server_list_v1_header *v1 = (void *)result;
+
+		if (v1->hdr.zero == 0 &&
+		    v1->hdr.content == DNS_PAYLOAD_IS_SERVER_LIST &&
+		    v1->hdr.version == 1 &&
+		    (v1->status != DNS_LOOKUP_GOOD &&
+		     v1->status != DNS_LOOKUP_GOOD_WITH_BAD))
+			return -ENOENT;
+
+	}
+
+	kfree(result);
 	return ret;
 }
 
-- 
2.43.0



