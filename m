Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591224;
	b=ytIG/cHVBd14rVzJKy5joO4LYDQwbVMTU2yadv3j4zjnjXCjKpsf2TAgQBXvLp88/ZWx
	 UEbAFyIcGHJtZXzGsajxxbH2H/nayQvfBb4Jfy9wanv2u0nQfxaE+5H5ek0EMY2Ie67KU
	 8VzEI7+ld/BzY/mXJz8tYWau8DaKBjMtniNly8xhDxfLkZYsDlo39d6rN3SUwGw28exyE
	 nSXtbhqV2reK3jWVgSZfS8+VTyHKgL+3CVU4VqLwVkxXmRof/Fe0UEqHNSPCa5NhHbp6M
	 GNzXKjSCBcj7eT/8tHAUBD4TvDXLuAn6Lb8wrJhQNjXq+kpoJKCAg37Gbj+ey6j8zww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tFSmQ8pTpjYXsYW/4rwNKMO4ilHVjNHtCgNgHTXey70=;
	b=BvASVG95x6Zbur11roxj00PzwkziY8SODZknExPjcEg+wzXrxyW1hZM6JEeOTXiQIECj
	 GNnbYJUTr6GfxH00j5zNflAkZoFckVVzzvDSoy7HxeZApWy/bTn0zTleQ8QGhAGlEx78k
	 hghS1AabQCKnn0jzh6nxDZkeMQ6PVuqMxm9b39dC9cfJaAkrOjKFVaJDE3fVZ+ocOr/oC
	 Jt5/1/rhYhGLtvNug/JY9q5kpUUg26fja6zy4ZMLlixzxdhigsGcOR5b/dTq+XKFW9C2w
	 9IQZIqsGTpVGBq/uXj4uHb+1B/ezioWTEm1tOHKdlXXGFy5niPp+1uWQsrO0TTNphGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eq7DlZpJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66646075E39;
	Fri, 13 Nov 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eq7DlZpJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502501F000C4;
	Fri, 13 Nov 2026 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591224;
	bh=tFSmQ8pTpjYXsYW/4rwNKMO4ilHVjNHtCgNgHTXey70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eq7DlZpJLfHdyY7K3Zf0/4E+JEG/DBUrVV7JlTGMkl835x+e2Uwft1RGbMOsWhHD3
	 BmK7Yyh0/bPRjaX+qT0PMITYdKc14WAiM30B2nDr6n26eB9gc8W+xtCNM3HXh8HihH
	 McHfqrvYYpvAVCazGtuc06rVjrAeXfs5KJkgXWto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/670] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Fri, 13 Nov 2026 10:48:39 -0500
Message-ID: <20261113153823.846678756@linuxfoundation.org>
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

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index c8ff53faddbc3..1cc2f57b53ffa 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -282,6 +282,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc(struct_size(desc, nsids, NVMET_MAX_NAMESPACES),
 		       GFP_KERNEL);
-- 
2.53.0



