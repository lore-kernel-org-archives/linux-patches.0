Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216268;
	b=YiXlEK6rUorHt3SdGGIpbHMLILpiImuiomGSj1I7LuL8tzxGjF3nhmkxQvQhlUmGXxSC
	 56UgesYzjVW+zIToozaCWyhIyGKwjC2H1lwHspVNiD66PDAdOjtLBFXSylPobJEdMh+D6
	 xRtpIhfwkoAAgMp2fObxtfM4yekkQe5mZ31T1vKR7407/7/DmUEzc7sCsDnbv6age/Ml+
	 mkaWRCb6zR+HXCnAgku4zvsyZVhSpV+taW+96rJxtkGIP3VuPCxZGwp1XBlSQIdTVVHih
	 sxDnamUHMkoHOXCBznBQoyrEG9NQmkgWlJWrw0BzCOaQEcvHCEntxS/eHT3kjETAC7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5JY1xE/7rc50qyU6cwdXwX+bez2iyHwUGUfcmV2N60=;
	b=f5Nq90JfMkkScIxC5DjHLEOyjxZrs3N9s/enFYqCJkcv0kk5Pk2gc/zB1bBxml6mn6vF
	 6Exob4JBSCAFvmvLTnDHWC61pSnMdzEkOq7IIxvCD+08ZuGi+EOkM65SzQ1jME4UBgFp9
	 nF4+CK8xkBQr8Ii8U3pWJcBkFfiW27yvZpyyaftEPaAGy7437xHiEuYFFnb2ypcaI0jfb
	 onimpAOrJeIK+ls4i+PnzWliAsDVrd5bRVwFGbD3WhyvI1hRSH8+7nQM7jWz2muWUGf/Q
	 tLIqH7ACVY6aeIvBeYY5bq9yIk3N08plJ6QEhuVgtNSxTH6CR0/am0HbL5+vFF8i6mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mq9W73d3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67B606A320;
	Wed, 28 Oct 2026 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mq9W73d3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FE01F01828;
	Wed, 28 Oct 2026 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216268;
	bh=H5JY1xE/7rc50qyU6cwdXwX+bez2iyHwUGUfcmV2N60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mq9W73d3MVQcXFBljVP2ck03qqD8XMh+HyMuOo8+8UXVW34tjPbydCEDhoi0sQoJ2
	 gbJs3tF+THWq92NKu57iVkL9cmNAnKBlDxaIdg+BZaklBpwKl0iRn4aRvMXvkqji0x
	 8CGFv5GjLn3isd0yKci0chxoDmrwr7suRSKPIfc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1497/1887] s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects
Date: Wed, 28 Oct 2026 17:59:53 +0100
Message-ID: <20261028170533.524369602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit 7fa61c29850d05e40ca9ed41bfdf57673023f581 ]

In order to traverse or add/remove ap_matrix_mdev objects in the
matrix_dev->mdev_list, the matrix_dev->guests_lock mutex must be held.
There are two functions that access the list without holding the mutex:

vfio_ap_mdev_probe function
~~~~~~~~~~~~~~~~~~~~~~~~~~~
The vfio_ap_mdev_probe function uses the matrix_dev->mdevs_lock
mutex to guard the add of a newly created ap_matrix_mdev object to the
matrix_dev->mdev_list. This mutex does not protect list access; its purpose
is to guard against concurrent access to fields contained in an
ap_matrix_mdev object. This could lead to kernel memory corruption or
use-after-free if another mdev is created or removed concurrently.

The adding of an ap_matrix_mdev object to matrix_dev->mdev_list
is now guarded by the matrix_dev->guests_lock which is the correct
way to protect against concurrent mdev_list access.

Also removed the following two lines of code because the matrix_mdev is
allocated via vfio_alloc_device macro which uses kzalloc, so req_trigger
and cfg_chg_trigger are already zero-initialised when the struct is
allocated before the call to vfio_register_emulated_iommu_dev. This
prevents a window whereby these triggers are set to NULL after
the device is exposed to userspace.

matrix_mdev->req_trigger = NULL;
matrix_mdev->cfg_chg_trigger = NULL;

vfio_ap_mdev_for_queue function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The status_show function that supports display of the status attribute of
the devices in /sys/bus/ap/devices calls the vfio_ap_mdev_for_queue
function which iterates the matrix_dev->mdev_list to find the object
representing the queue device whose status is to be displayed. In order to
traverse this list, the matrix_dev->guests_lock mutex must be held.

To fix this, the guests_lock mutex is taken prior to taking the
matrix_dev->mdevs_lock mutex in the status_show function. It is taken
there rather than the vfio_ap_mdev_for_queue function - where it is
needed - because it must be taken prior to the mdevs_lock mutex in order to
adhere to the proper locking order and prevent a lockdep splat; also
because the mdevs_lock is needed there to access fields within
the matrix_mdev object in that function.

See the vfio-ap-locking.rst in the linux kernel tree.

Fixes: 2c1ee8983aa3 ("s390/vfio-ap: prepare for dynamic update of guest's APCB on queue probe/remove")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0d884f340dc1c..8f984ecef02b4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -714,10 +714,17 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_put_vdev;
+
+	/*
+	 * Take the matrix_dev->guests_lock mutex before adding the matrix_mdev
+	 * to the mdev_list. All functions that traverse the list must also hold
+	 * this lock to guard against additions to or removals from the list
+	 * while it is being traversed.
+	 */
+	mutex_lock(&matrix_dev->guests_lock);
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
-	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 	return 0;
 
 err_put_vdev:
@@ -1747,6 +1754,8 @@ static struct ap_matrix_mdev *vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
 	unsigned long apid = AP_QID_CARD(q->apqn);
 	unsigned long apqi = AP_QID_QUEUE(q->apqn);
 
+	lockdep_assert_held(&matrix_dev->guests_lock);
+
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
@@ -1766,6 +1775,7 @@ static ssize_t status_show(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
+	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 
@@ -1814,6 +1824,7 @@ static ssize_t status_show(struct device *dev,
 
 done:
 	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return nchars;
 }
@@ -2208,6 +2219,12 @@ static void vfio_ap_mdev_cfg_add(unsigned long *apm_add, unsigned long *aqm_add,
 
 	vfio_ap_filter_apid_by_qtype(apm_add, aqm_add);
 
+	/*
+	 * It is safe to traverse this list here because the
+	 * required guard - matrix_dev->guests_lock - is taken in the
+	 * vfio_ap_on_cfg_changed function prior to this function getting
+	 * called.
+	 */
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		/*
 		 * The mdevs_lock must be held in order to access fields
@@ -2275,6 +2292,10 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *cur_cfg_info,
 	if (!cur_cfg_info || !prev_cfg_info)
 		return;
 
+	/*
+	 * Take the guests_lock mutex here to guard access to the
+	 * matrix_dev->mdev_list in the two functions called below.
+	 */
 	mutex_lock(&matrix_dev->guests_lock);
 
 	vfio_ap_mdev_on_cfg_remove(cur_cfg_info, prev_cfg_info);
-- 
2.53.0



