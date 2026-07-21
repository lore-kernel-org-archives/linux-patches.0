Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64094446EA;
	Tue, 21 Jul 2026 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668082; cv=none; b=sqjc6X/Rg1CoRvP8bRoTjtKWzMKG05ch+VsRvKMBwo0DRz156NOOF/RxgpXDZDXun8AcLaTEqaw2xfA4SbLkDZXnOe66uzIowkqC7nQbAE7KAn76YTO4c/Hrunwwpb0Jv4YfFti9AP/rJymzYmNlfImdjBXuiXcFyjn36VTaa0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668082; c=relaxed/simple;
	bh=tapXgIuXEKW933Y9h2meXcV7aPh1LDtcHsUn3R7u930=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcX2abztdr+WGUSuVr1W/WA8DKpuiCEYcXQSImZnuFtta6SeOde9eredebDG3sfYer7xa+k4zeJlxCyOyzbdTpYctBUD9ABgPeKT00AjZgdZ/o7sSFi4t2kYPJ7xJE+cwbaikFF4mn64oL1h5jMK80asSn9T+hB4z4O6nLfhokg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSIHpEUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSIHpEUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218041F000E9;
	Tue, 21 Jul 2026 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668081;
	bh=VVarg6RYx9kvedrBmmvQJtjaXp0KxM5GH8B08wSS3hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSIHpEUmxVrYuVElv570AHp/YBtZy7wXeoK5+km7qPVV1y1Q/4s5NJaG/MPOsrrDv
	 hWk/zhIfEwe8Ck+MqwZ97CvysggrHUaTPqEkiOL+TC62Ol4Wxc1C7MdSVZLGw11giv
	 OUq/+7yeW3yFfJynWu/VBzUG8XvyRs80MteHtn9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	carnil@debian.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 0040/1067] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Tue, 21 Jul 2026 17:10:41 +0200
Message-ID: <20260721152425.453040452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3d9fd0abc94d8cd430cc7cd7d37ce5e5aae2cd2b ]

Replace the open-coded "epi is the only entry in file->f_ep" check
with hlist_is_singular_node(). Same semantics, and the helper avoids
the head-cacheline access in the common false case.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-1-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -745,7 +745,7 @@ static bool __ep_remove(struct eventpoll
 
 	to_free = NULL;
 	head = file->f_ep;
-	if (head->first == &epi->fllink && !epi->fllink.next) {
+	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {


