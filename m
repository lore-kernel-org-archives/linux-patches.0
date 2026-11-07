Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063676;
	b=3msJPf0VYNC9/yBWcC4MmTDifiOmqG3l16JeuyhFuiuWSVwJJd7DUfB7x9/k3WuHsRtP
	 Ta1GHu9fOZLW9qoz+8FtGX8v+lf0OJyQm+gSYT7l46ViFtfirev/AJfFJ9MCIW8IGcZi0
	 boMyD0WzXzMVdaTjnHp5KyKRJIoMCYTQpxT4ihF8i+b7bu81SOJ9Ttro1y02dgFJTBOTM
	 0UfKnrEgs/NE6z9YsGZKEIq4l+XJohyU9yTPKUyyioODHjwt0KzGeWdKNbaC8+t/5/n2d
	 KTSYzARh+81w4FvhPhY//R2yfwvcWPw5N/yQ7stOdcWy2Oh8ne0bsnJ5SF5HP3xg4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrKwdPieDV43IMjmIpZRIjjnDkw01kAmGWknhqpeOPI=;
	b=Ufqg3ukPZ22XbVb8VTG4nkPCJXZvxSolR6YmM4iAVUAYYMXF80i0RxBt3dkU2lBzkLUJ
	 Oh9JrkspHDNBkqsM6SKx68oYXMECzCWuH6PQ0S+cvxgfWlz27Lhx34svCHgb9vHzkC4u8
	 KtxUZtewWwUbjNKMt1U8ahAvCxy3iwSB8b4o+QPxmWWmdXtIzDsHLq0/49JaeqgrIsFL4
	 x/vS8LjG4P7DFol1/jhG7Ve3eT9oesUMVdCMDHun14IceLdavPkoFFug1flRjVSyRJeTd
	 WBOPp+As2Mnp0TVkXCBgneFeU3vfJxBqKhqWDFBZQP3F8BwCGcftqUp1E4g5We+hzOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWxlHrAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A79606A9EF;
	Sat,  7 Nov 2026 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWxlHrAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150801F0089F;
	Sat,  7 Nov 2026 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063676;
	bh=ZrKwdPieDV43IMjmIpZRIjjnDkw01kAmGWknhqpeOPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWxlHrAcVtpHFwfayK9N4NWDXwIQQ4Pk5JJxBlOJsO3MrhqJxtjUp6IV45+1DxBEh
	 L4C28foigW8xryJPh6TN2CEAVG5y0z3y+iUVga2Wmx3mTWLiFA7XaYU1WOtqLlS7q+
	 0ibVcwO52gf7e+rGwa78ZCnjaReG7pDE5PiMmk7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 786/869] ceph: fix uninitialized err in ceph_netfs_issue_read()
Date: Sat,  7 Nov 2026 08:57:48 -0500
Message-ID: <20261107134919.375957409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit 823d21c78453fcdf58dbd8ecefbb41f4f3eb6540 ]

ceph_netfs_issue_read() declares err without an initializer. On the
unencrypted, non-sparse success path nothing assigns it, then the
out: label does if (err) netfs_read_subreq_terminated(subreq).

With CONFIG_INIT_STACK_ALL_PATTERN, err is 0xaaaaaaaa (nonzero), so
the subrequest is terminated while the OSD READ is still in flight.
netfs then frees the rolling buffer that the OSD iterator still
points at, causing a KASAN UAF / oops, and finish_netfs_read()
terminates the same subrequest a second time. CONFIG_INIT_STACK_ALL_ZERO
hides it because err happens to be 0.

Restore the err = 0 initializer so a successful submit leaves
completion to finish_netfs_read() only.

Cc: stable@vger.kernel.org
Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index fe8b7b4f6e8bf..51aeae341f56d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -362,7 +362,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct ceph_client *cl = fsc->client;
 	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
-	int err;
+	int err = 0;
 	u64 len;
 	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 off = subreq->start;
-- 
2.53.0



