Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7916930FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31F4C433C9;
	Wed, 20 Sep 2023 12:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212910;
	bh=7aRBocy9PCWG2n0jxQ2p5f7tchaUn46KGIJrnJ+l24o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDUosapK2WCEC1fiLd2sDrF0Zb6wqv569PXTNw5KYL8MqQ2g4mCPUTZNNnXHwB8+p
	 WHen0Cip3J0nVSvX46EwSA/1lPTmgmG0X6eM/Ameq25SLVOAkqV6n6wdqck6gZJREs
	 p8a7MJCmpU6x+fPO5KPA+LBjvlx9nZyxjnAv4Q2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/367] quota: rename dquot_active() to inode_quota_active()
Date: Wed, 20 Sep 2023 13:27:47 +0200
Message-ID: <20230920112900.870182876@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4b9bdfa16535de8f49bf954aeed0f525ee2fc322 ]

Now we have a helper function dquot_dirty() to determine if dquot has
DQ_MOD_B bit. dquot_active() can easily be misunderstood as a helper
function to determine if dquot has DQ_ACTIVE_B bit. So we avoid this by
renaming it to inode_quota_active() and later on we will add the helper
function dquot_active() to determine if dquot has DQ_ACTIVE_B bit.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230630110822.3881712-3-libaokun1@huawei.com>
Stable-dep-of: dabc8b207566 ("quota: fix dqput() to follow the guarantees dquot_srcu should provide")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 806a404e7156e..7abf1ae05f939 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1409,7 +1409,7 @@ static int info_bdq_free(struct dquot *dquot, qsize_t space)
 	return QUOTA_NL_NOWARN;
 }
 
-static int dquot_active(const struct inode *inode)
+static int inode_quota_active(const struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -1432,7 +1432,7 @@ static int __dquot_initialize(struct inode *inode, int type)
 	qsize_t rsv;
 	int ret = 0;
 
-	if (!dquot_active(inode))
+	if (!inode_quota_active(inode))
 		return 0;
 
 	dquots = i_dquot(inode);
@@ -1540,7 +1540,7 @@ bool dquot_initialize_needed(struct inode *inode)
 	struct dquot **dquots;
 	int i;
 
-	if (!dquot_active(inode))
+	if (!inode_quota_active(inode))
 		return false;
 
 	dquots = i_dquot(inode);
@@ -1651,7 +1651,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	int reserve = flags & DQUOT_SPACE_RESERVE;
 	struct dquot **dquots;
 
-	if (!dquot_active(inode)) {
+	if (!inode_quota_active(inode)) {
 		if (reserve) {
 			spin_lock(&inode->i_lock);
 			*inode_reserved_space(inode) += number;
@@ -1721,7 +1721,7 @@ int dquot_alloc_inode(struct inode *inode)
 	struct dquot_warn warn[MAXQUOTAS];
 	struct dquot * const *dquots;
 
-	if (!dquot_active(inode))
+	if (!inode_quota_active(inode))
 		return 0;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warn[cnt].w_type = QUOTA_NL_NOWARN;
@@ -1764,7 +1764,7 @@ int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 	struct dquot **dquots;
 	int cnt, index;
 
-	if (!dquot_active(inode)) {
+	if (!inode_quota_active(inode)) {
 		spin_lock(&inode->i_lock);
 		*inode_reserved_space(inode) -= number;
 		__inode_add_bytes(inode, number);
@@ -1806,7 +1806,7 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
 	struct dquot **dquots;
 	int cnt, index;
 
-	if (!dquot_active(inode)) {
+	if (!inode_quota_active(inode)) {
 		spin_lock(&inode->i_lock);
 		*inode_reserved_space(inode) += number;
 		__inode_sub_bytes(inode, number);
@@ -1850,7 +1850,7 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 	struct dquot **dquots;
 	int reserve = flags & DQUOT_SPACE_RESERVE, index;
 
-	if (!dquot_active(inode)) {
+	if (!inode_quota_active(inode)) {
 		if (reserve) {
 			spin_lock(&inode->i_lock);
 			*inode_reserved_space(inode) -= number;
@@ -1905,7 +1905,7 @@ void dquot_free_inode(struct inode *inode)
 	struct dquot * const *dquots;
 	int index;
 
-	if (!dquot_active(inode))
+	if (!inode_quota_active(inode))
 		return;
 
 	dquots = i_dquot(inode);
@@ -2076,7 +2076,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	struct super_block *sb = inode->i_sb;
 	int ret;
 
-	if (!dquot_active(inode))
+	if (!inode_quota_active(inode))
 		return 0;
 
 	if (iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)){
-- 
2.40.1



