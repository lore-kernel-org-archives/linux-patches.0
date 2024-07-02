Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88EA15B0FE;
	Tue,  2 Jul 2024 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940485; cv=none; b=K0Zzt6V8eKY969LUF+eIP9ZEMWlBvpS/6PT8bnEG/FxO32U31C4ZyEBvuV9dbGy8clJJhiGHKhud2o0N7tvGtwRaDq8jLi2v9kO8DVr0t2yQ8yFYa6p3wsXn4ApTGipx6ApepFRveONmB0ceXuHs3lBQhW3ba0xVKbzwiKNng5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940485; c=relaxed/simple;
	bh=tSyv2BNtAwtAK4eDX6CWiioKg6d2/QZ7kY6StIV4TT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Chu+4O0hqN3yni07dLJ4UD9UMaHT7XbDRcIdTyr5yYNd4ovI168RpSdOfFOUY2Zn1E6umOUmqZyqGarNLckhsoR/Yofcx4OsRJDf3fNqoGMeypn89jxKr5gBl3b8gFTSUjUfZD+Rnn1bvA/d4Bu0RpZzul3L7IsECQ59OmUYH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EI/rL7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EI/rL7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4BFC116B1;
	Tue,  2 Jul 2024 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940484;
	bh=tSyv2BNtAwtAK4eDX6CWiioKg6d2/QZ7kY6StIV4TT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EI/rL7j32BZscO1KZxzRkXBoEBVeMZ/AGiDHym076pbpFU3S9tH+jn1BCW1z9t8W
	 CQWYrw8zjYjrCNsLEqBSR5pHbBH3GPgqd4gJzLkpnq1quVBdxjYj/FS0+0dKa9lFhA
	 UcmPHnBRx0RVNIncXhIhYfvT8Ll3rV54BAVsPBL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.9 168/222] nvmet-fc: Remove __counted_by from nvmet_fc_tgt_queue.fod[]
Date: Tue,  2 Jul 2024 19:03:26 +0200
Message-ID: <20240702170250.397887175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 440e2051c577896275c0e0513ec26964e04c7810 upstream.

Work for __counted_by on generic pointers in structures (not just
flexible array members) has started landing in Clang 19 (current tip of
tree). During the development of this feature, a restriction was added
to __counted_by to prevent the flexible array member's element type from
including a flexible array member itself such as:

  struct foo {
    int count;
    char buf[];
  };

  struct bar {
    int count;
    struct foo data[] __counted_by(count);
  };

because the size of data cannot be calculated with the standard array
size formula:

  sizeof(struct foo) * count

This restriction was downgraded to a warning but due to CONFIG_WERROR,
it can still break the build. The application of __counted_by on the fod
member of 'struct nvmet_fc_tgt_queue' triggers this restriction,
resulting in:

  drivers/nvme/target/fc.c:151:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct nvmet_fc_fcp_iod' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
    151 |         struct nvmet_fc_fcp_iod         fod[] __counted_by(sqsize);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Remove this use of __counted_by to fix the warning/error. However,
rather than remove it altogether, leave it commented, as it may be
possible to support this in future compiler releases.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2027
Fixes: ccd3129aca28 ("nvmet-fc: Annotate struct nvmet_fc_tgt_queue with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -148,7 +148,7 @@ struct nvmet_fc_tgt_queue {
 	struct workqueue_struct		*work_q;
 	struct kref			ref;
 	/* array of fcp_iods */
-	struct nvmet_fc_fcp_iod		fod[] __counted_by(sqsize);
+	struct nvmet_fc_fcp_iod		fod[] /* __counted_by(sqsize) */;
 } __aligned(sizeof(unsigned long long));
 
 struct nvmet_fc_hostport {


