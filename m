Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC68837;
	Mon, 28 Oct 2024 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098120; cv=none; b=hgAy4FG0qMb4wb+iSQDPOWP3M6GXFwLNKMXt8KscDncoBoT35OqvheBKQ6xCRsmuKc6RpI3Um6IJG8NIsNu2EOabeHZ38A47QzRiopADGD3l6GxUJlafkvDeko9HIMe+S5ksOnWOTkdzWgkpdNOOUXLUcFClGo4BXvybrDKUxpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098120; c=relaxed/simple;
	bh=vvrcydDbCGySxa1mwBuiicBUm5nmY+4No7ZECmP0lyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SkyJTPzxTYJi/WDG3oQWsKmAHF7oZRNceD7eb2OKiQ6j1Pf8LVbw3rHQllHLztk3PWt1aeKYGAuuaqd8Ty89dKaOjjg5sErRokAelJTnHaaSTIFN/F+DSlH6MG2aMbqu9XPQzo5sht798VQjOXFanpjAibCE7CXR0QSBnOj3NuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2AmiaIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2AmiaIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6278EC4CEC3;
	Mon, 28 Oct 2024 06:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098119;
	bh=vvrcydDbCGySxa1mwBuiicBUm5nmY+4No7ZECmP0lyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2AmiaIbqiNmO6oz7Et7pVBq/GrZtKRrVXsd9x4+nErG1fX9wCO5tBF+atoOvAV0r
	 WCo7QIpWQFgTixKqcXefnknmTvqUZ6NYD7PehMsYfKBaacqGpeK2VBT4GZJAbtNeG9
	 MYyHHcqG7PqP3h4MGXzAPUPxFFDNxsU19U+dHxV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Su Hui <suhui@nfschina.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 085/261] smb: client: fix possible double free in smb2_set_ea()
Date: Mon, 28 Oct 2024 07:23:47 +0100
Message-ID: <20241028062314.163914109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 19ebc1e6cab334a8193398d4152deb76019b5d34 ]

Clang static checker(scan-build) warning：
fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
 1304 |         kfree(ea);
      |         ^~~~~~~~~

There is a double free in such case:
'ea is initialized to NULL' -> 'first successful memory allocation for
ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
-> 'goto replay_again' -> 'second goto sea_exit before allocate memory
for ea' -> 'second memory release for ea resulted in double free'.

Re-initialie 'ea' to NULL near to the replay_again label, it can fix this
double free problem.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e9be7b43bb6b8..b9e332443b0d9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1156,7 +1156,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	unsigned int size[1];
 	void *data[1];
-	struct smb2_file_full_ea_info *ea = NULL;
+	struct smb2_file_full_ea_info *ea;
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
 	int retries = 0, cur_sleep = 1;
@@ -1177,6 +1177,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
+	ea = NULL;
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
 	if (!vars) {
-- 
2.43.0



