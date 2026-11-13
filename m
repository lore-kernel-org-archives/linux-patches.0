Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590969;
	b=0Ghdw0ZUiqgqEqzWARhSTekbg7p8ga/OKHh3or1ryGL5QdjwIFoHp8S70LkVKUlROjhG
	 xmkpZFf96AgBtR2UExEqvjhWYBIEe2mpDt5kg2mX7+G1DyEr5MOGGmS77alQGapAFv8N4
	 SHjsCJMAog33HT95Xgn90Gt2cxWoXxAAO1MSy4RrlMsHVorj5254/G+xizqWLFLf9a0DM
	 1q2F24Wy15FXAD++fZpxB0PpEkxA61wCbzqLWzj3OnG+WVfK2MG8un+rilhKWOkHNmuwC
	 mYrPyiZ4oacxWKtpgwTlARzhX7fBBxij7/8i1gI/Tys+bFOeOPyw+GYKeB7Fvvs5v0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G1X4y2Wt8zADi4pNUYPeFJewwrtL9V82Z8hiCfUDGFc=;
	b=xRGr8mOofEH11vRcB8tBph7xHZqD1FU6ZKEyYj0qrXy8aueMC9km29kBGMgXu+sE5UFB
	 zprsPHchxeBuGu/z425a/Iikd/05zOEZlKyjs6Ca2YXwgVejZz/JTQbqpsZh22CipwwLl
	 j5iOw8twYE47l2UkBneZUlTaZAyGNYkyB00ryyTiEfQgeweLDeV9phEcgAaUBeq0AiIao
	 u+boTGcci0DhZxpzMrGqgPKavFDn3AvlYK8OVF0+QKE4BiNPfGoCYoMo4o7qqw6K++ISH
	 Zp1pE7UBOkjlrm3KNmCYB6ziPLCKC38gfPgxjbtEeR4HiEu3YgxxVnAR/XQ/sa2rleQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdUeg4n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157E8606A8A3;
	Fri, 13 Nov 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdUeg4n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B558D1F000C4;
	Fri, 13 Nov 2026 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590968;
	bh=G1X4y2Wt8zADi4pNUYPeFJewwrtL9V82Z8hiCfUDGFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdUeg4n75ViyJAWcBMcXUuhdt1hdK8udC8HQV1GhltMI/BbayplWJh+81dKyV8EIs
	 nM2n09SVLEqaVC3jQag+4UuM6fT9g57nasCZX+8UY3ljyHJLqAlME+8QKaatGa5xkx
	 6n29fKJjN/oyWveO8Ho2eTc1Nj4rZfo7ne9Jf0Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/670] bpqether: fix truncated /proc/net/bpqether on partial reads
Date: Fri, 13 Nov 2026 10:44:28 -0500
Message-ID: <20261113153815.403085529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

bpq_seq_start() walks the device list to find the entry at *pos, but
never increments its counter. It returns the first device when *pos is
1 and NULL for any larger value.

The seq_file core calls ->start() with the saved position each time a
read() needs more data, so the listing stops after the first device as
soon as it is not produced in a single pass: when it is read with a
small buffer, or when it is longer than a page.

With five bpq devices, reading the file 64 bytes at a time returned
the header and one device before the change, and all five devices
after.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 0a529c12d374e1dc74c2360e7ca13ab4e594a445)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index c896b778b77b1..f027205347d34 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -386,6 +386,7 @@ static void *bpq_seq_start(struct seq_file *seq, loff_t *pos)
 	list_for_each_entry_rcu(bpqdev, &bpq_devices, bpq_list) {
 		if (i == *pos)
 			return bpqdev;
+		i++;
 	}
 	return NULL;
 }
-- 
2.53.0



